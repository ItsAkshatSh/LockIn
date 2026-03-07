import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lock_in/features/analytics/models/analytics_event.dart';
import 'package:lock_in/features/analytics/repositories/analytics_repository.dart';

final analyticsRepositoryProvider = Provider((ref) => AnalyticsRepository());

final analyticsNotifierProvider = Provider((ref) {
  final repository = ref.watch(analyticsRepositoryProvider);
  return AnalyticsService(repository);
});

class AnalyticsService {
  final AnalyticsRepository _repository;

  AnalyticsService(this._repository);

  Future<void> logEvent(String name, {Map<String, dynamic> metadata = const {}}) async {
    await _repository.init();
    final event = AnalyticsEvent(
      name: name,
      timestamp: DateTime.now(),
      metadata: metadata,
    );
    await _repository.logEvent(event);
    
    developer.log(
      'Event: $name | Metadata: $metadata',
      name: 'APP.ANALYTICS',
      time: event.timestamp,
    );
  }

  Future<void> printAllEvents() async {
    await _repository.init();
    final events = await _repository.getEvents();
    for (var event in events) {
      developer.log(
        '${event.name}: ${event.metadata}',
        name: 'APP.ANALYTICS.HISTORY',
        time: event.timestamp,
      );
    }
  }

  Future<List<AnalyticsEvent>> getLoggedEvents() async {
    await _repository.init();
    return _repository.getEvents();
  }
}
