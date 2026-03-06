import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lock_in/features/ambience/models/ambience_model.dart';
import 'package:lock_in/features/ambience/providers/ambience_providers.dart';
import 'package:lock_in/features/ambience/presentation/widgets/ambience_card.dart';
import 'package:lock_in/shared/widgets/mini_player.dart';
import 'package:lock_in/features/journal/presentation/pages/journal_history_page.dart';
import 'package:lock_in/features/settings/presentation/pages/settings_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAmbiencesAsync = ref.watch(filteredAmbiencesProvider);
    final selectedTag = ref.watch(filterTagProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Ambiences'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const JournalHistoryPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search ambiences...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: selectedTag == null,
                      onSelected: (_) => ref.read(filterTagProvider.notifier).state = null,
                    ),
                    const SizedBox(width: 8),
                    ...['Focus', 'Calm', 'Sleep', 'Reset'].map((tag) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(tag),
                        selected: selectedTag == tag,
                        onSelected: (selected) {
                          ref.read(filterTagProvider.notifier).state = selected ? tag : null;
                        },
                      ),
                    )),
                  ],
                ),
              ),
              Expanded(
                child: filteredAmbiencesAsync.when(
                  data: (ambiences) {
                    if (ambiences.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('No ambiences found'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(searchQueryProvider.notifier).state = '';
                                ref.read(filterTagProvider.notifier).state = null;
                              },
                              child: const Text('Clear Filters'),
                            ),
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: ambiences.length,
                      itemBuilder: (context, index) {
                        return AmbienceCard(ambience: ambiences[index]);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}
