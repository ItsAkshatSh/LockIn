class JournalEntry {
  final String id;
  final String ambienceTitle;
  final String mood;
  final String text;
  final DateTime dateTime;

  JournalEntry({
    required this.id,
    required this.ambienceTitle,
    required this.mood,
    required this.text,
    required this.dateTime,
  });
}
