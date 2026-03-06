import 'package:hive_flutter/hive_flutter.dart';
import 'package:lock_in/features/analytics/models/analytics_event.dart';

class AnalyticsRepository {
  static const String boxName = 'analytics_events';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  }

  Future<void> logEvent(AnalyticsEvent event) async {
    final box = Hive.box(boxName);
    await box.add(event.toMap());
  }

  Future<List<AnalyticsEvent>> getEvents() async {
    final box = Hive.box(boxName);
    return box.values.map((e) {
      return AnalyticsEvent.fromMap(Map<String, dynamic>.from(e));
    }).toList().reversed.toList();
  }
}
