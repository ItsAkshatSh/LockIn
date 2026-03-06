import 'package:hive_flutter/hive_flutter.dart';
import 'package:lock_in/features/journal/models/journal_entry.dart';

class JournalRepository {
  static const String boxName = 'journal_entries';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      // For this demo, since I can't run build_runner, 
      // I'll register the adapter manually or use a simple map box
      // Hive.registerAdapter(JournalEntryAdapter()); 
      await Hive.openBox(boxName);
    }
  }

  Future<void> saveEntry(JournalEntry entry) async {
    final box = Hive.box(boxName);
    await box.add({
      'id': entry.id,
      'ambienceTitle': entry.ambienceTitle,
      'mood': entry.mood,
      'text': entry.text,
      'dateTime': entry.dateTime.toIso8601String(),
    });
  }

  Future<List<JournalEntry>> getEntries() async {
    final box = Hive.box(boxName);
    return box.values.map((e) {
      final map = Map<String, dynamic>.from(e);
      return JournalEntry(
        id: map['id'],
        ambienceTitle: map['ambienceTitle'],
        mood: map['mood'],
        text: map['text'],
        dateTime: DateTime.parse(map['dateTime']),
      );
    }).toList().reversed.toList();
  }
}
