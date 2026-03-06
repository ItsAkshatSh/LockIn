class AnalyticsEvent {
  final String name;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  AnalyticsEvent({
    required this.name,
    required this.timestamp,
    this.metadata = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory AnalyticsEvent.fromMap(Map<String, dynamic> map) {
    return AnalyticsEvent(
      name: map['name'],
      timestamp: DateTime.parse(map['timestamp']),
      metadata: Map<String, dynamic>.from(map['metadata']),
    );
  }
}
