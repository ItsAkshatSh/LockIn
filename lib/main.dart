import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lock_in/features/home/presentation/pages/home_page.dart';
import 'package:lock_in/shared/theme/app_theme.dart';
import 'package:lock_in/features/settings/providers/settings_provider.dart';
import 'package:lock_in/features/player/providers/player_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const ProviderScope(child: LockInApp()));
}

class LockInApp extends ConsumerStatefulWidget {
  const LockInApp({super.key});

  @override
  ConsumerState<LockInApp> createState() => _LockInAppState();
}

class _LockInAppState extends ConsumerState<LockInApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.read(playerProvider.notifier).handleLifecycleChange(state);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'LockIn',
      theme: AppTheme.getTheme(settings.themeColor, Brightness.light),
      darkTheme: AppTheme.getTheme(settings.themeColor, Brightness.dark),
      themeMode: settings.themeMode,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
