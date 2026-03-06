import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lock_in/features/ambience/models/ambience_model.dart';
import 'package:lock_in/features/ambience/repositories/ambience_repository.dart';

final ambienceRepositoryProvider = Provider((ref) => AmbienceRepository());

final ambiencesProvider = FutureProvider<List<Ambience>>((ref) async {
  final repository = ref.watch(ambienceRepositoryProvider);
  return repository.getAmbiences();
});

final searchQueryProvider = StateProvider<String>((ref) => '');
final filterTagProvider = StateProvider<String?>((ref) => null);

final filteredAmbiencesProvider = Provider<AsyncValue<List<Ambience>>>((ref) {
  final ambiencesAsync = ref.watch(ambiencesProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final filterTag = ref.watch(filterTagProvider);

  return ambiencesAsync.whenData((ambiences) {
    return ambiences.where((ambience) {
      final matchesSearch = ambience.title.toLowerCase().contains(searchQuery);
      final matchesFilter = filterTag == null || ambience.tag == filterTag;
      return matchesSearch && matchesFilter;
    }).toList();
  });
});
