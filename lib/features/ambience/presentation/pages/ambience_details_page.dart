import 'package:flutter/material.dart';
import 'package:lock_in/features/ambience/models/ambience_model.dart';
import 'package:lock_in/features/player/presentation/pages/session_player_page.dart';
import 'package:lock_in/shared/widgets/mini_player.dart';

class AmbienceDetailsPage extends StatelessWidget {
  final Ambience ambience;

  const AmbienceDetailsPage({super.key, required this.ambience});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    ambience.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey[300]),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            ambience.title,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Chip(
                          label: Text(ambience.tag),
                          backgroundColor: colorScheme.primaryContainer,
                          labelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
                          side: BorderSide.none,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${ambience.duration ~/ 60} minutes session',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      ambience.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Sensory Recipe',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ambience.recipe
                          .map((item) => Chip(
                                label: Text(item),
                                avatar: Icon(
                                  Icons.auto_awesome,
                                  size: 16,
                                  color: colorScheme.primary,
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SessionPlayerPage(ambience: ambience),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text(
                        'Start Session',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 100), // Space for MiniPlayer
                  ]),
                ),
              ),
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
