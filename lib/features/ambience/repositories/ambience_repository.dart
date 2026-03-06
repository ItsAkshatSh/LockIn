import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:lock_in/features/ambience/models/ambience_model.dart';

class AmbienceRepository {
  Future<List<Ambience>> getAmbiences() async {
    final String response = await rootBundle.loadString('assets/data/ambiences.json');
    final data = await json.decode(response) as List;
    return data.map((e) => Ambience.fromJson(e)).toList();
  }
}
