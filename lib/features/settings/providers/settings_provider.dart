import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lock_in/shared/theme/app_theme.dart';

class SettingsState {
  final AppThemeColor themeColor;
  final ThemeMode themeMode;

  SettingsState({
    this.themeColor = AppThemeColor.deepPurple,
    this.themeMode = ThemeMode.system,
  });

  SettingsState copyWith({
    AppThemeColor? themeColor,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      themeColor: themeColor ?? this.themeColor,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  static const String boxName = 'settings_box';
  
  SettingsNotifier() : super(SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final box = await Hive.openBox(boxName);
    
    final colorIndex = box.get('themeColorIndex', defaultValue: AppThemeColor.deepPurple.index);
    final themeModeIndex = box.get('themeModeIndex', defaultValue: ThemeMode.system.index);
    
    state = state.copyWith(
      themeColor: AppThemeColor.values[colorIndex],
      themeMode: ThemeMode.values[themeModeIndex],
    );
  }

  Future<void> setThemeColor(AppThemeColor color) async {
    state = state.copyWith(themeColor: color);
    final box = Hive.box(boxName);
    await box.put('themeColorIndex', color.index);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final box = Hive.box(boxName);
    await box.put('themeModeIndex', mode.index);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
