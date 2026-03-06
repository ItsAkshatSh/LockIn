import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lock_in/features/ambience/models/ambience_model.dart';
import 'package:lock_in/features/journal/models/journal_entry.dart';
import 'package:lock_in/features/journal/providers/journal_providers.dart';
import 'package:lock_in/features/journal/presentation/pages/journal_history_page.dart';
import 'package:lock_in/features/player/providers/player_providers.dart';
import 'package:lock_in/features/analytics/providers/analytics_provider.dart';
import 'package:uuid/uuid.dart';

class ReflectionPage extends ConsumerStatefulWidget {
  final Ambience ambience;

  const ReflectionPage({super.key, required this.ambience});

  @override
  ConsumerState<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends ConsumerState<ReflectionPage> {
  final _textController = TextEditingController();
  String _selectedMood = 'Calm';
  final List<String> _moodOptions = ['Calm', 'Grounded', 'Energized', 'Sleepy'];

  void _onSave() async {
    final entry = JournalEntry(
      id: const Uuid().v4(),
      ambienceTitle: widget.ambience.title,
      mood: _selectedMood,
      text: _textController.text,
      dateTime: DateTime.now(),
    );

    await ref.read(journalNotifierProvider.notifier).addEntry(entry);
    
    // Log journal_saved event
    ref.read(analyticsNotifierProvider).logEvent('journal_saved', metadata: {
      'ambience': widget.ambience.title,
      'mood': _selectedMood,
      'char_count': _textController.text.length,
    });

    ref.read(playerProvider.notifier).resetSession();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const JournalHistoryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post-Session Reflection'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What is gently present with you right now?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _textController,
              maxLines: 6,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Share your thoughts...',
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Mood',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _moodOptions.map((mood) => ChoiceChip(
                label: Text(mood),
                selected: _selectedMood == mood,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedMood = mood);
                  }
                },
              )).toList(),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: _onSave,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text(
                'Save Reflection',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
