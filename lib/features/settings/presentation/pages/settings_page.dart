import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lock_in/features/settings/providers/settings_provider.dart';
import 'package:lock_in/shared/theme/app_theme.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Appearance', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text('Dark Mode'),
            trailing: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.settings_brightness)),
                ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode)),
                ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode)),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (Set<ThemeMode> newSelection) {
                ref.read(settingsProvider.notifier).setThemeMode(newSelection.first);
              },
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('Theme Color', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 12,
              children: AppThemeColor.values.map((color) {
                return ChoiceChip(
                  label: Text(color.label),
                  selected: settings.themeColor == color,
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(settingsProvider.notifier).setThemeColor(color);
                    }
                  },
                );
              }).toList(),
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('About', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const ListTile(
            title: Text('LockIn Version'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
