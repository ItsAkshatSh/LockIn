import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lock_in/features/journal/models/journal_entry.dart';
import 'package:lock_in/features/journal/repositories/journal_repository.dart';

final journalRepositoryProvider = Provider((ref) => JournalRepository());

final journalEntriesProvider = FutureProvider<List<JournalEntry>>((ref) async {
  final repository = ref.watch(journalRepositoryProvider);
  await repository.init();
  return repository.getEntries();
});

class JournalNotifier extends StateNotifier<AsyncValue<void>> {
  final JournalRepository _repository;
  final Ref _ref;

  JournalNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> addEntry(JournalEntry entry) async {
    state = const AsyncValue.loading();
    try {
      await _repository.init();
      await _repository.saveEntry(entry);
      state = const AsyncValue.data(null);
      // Refresh the entries provider
      _ref.invalidate(journalEntriesProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final journalNotifierProvider = StateNotifierProvider<JournalNotifier, AsyncValue<void>>((ref) {
  return JournalNotifier(ref.watch(journalRepositoryProvider), ref);
});
