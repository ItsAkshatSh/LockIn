import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lock_in/features/ambience/models/ambience_model.dart';
import 'package:lock_in/features/player/providers/player_providers.dart';
import 'package:lock_in/features/journal/presentation/pages/reflection_page.dart';

class SessionPlayerPage extends ConsumerStatefulWidget {
  final Ambience ambience;

  const SessionPlayerPage({super.key, required this.ambience});

  @override
  ConsumerState<SessionPlayerPage> createState() => _SessionPlayerPageState();
}

class _SessionPlayerPageState extends ConsumerState<SessionPlayerPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(playerProvider.notifier).startSession(widget.ambience);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _onEndSession() async {
    final shouldEnd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session?'),
        content: const Text('Are you sure you want to end your session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('End'),
          ),
        ],
      ),
    );

    if (shouldEnd == true) {
      if (!mounted) return;
      ref.read(playerProvider.notifier).endSessionManually();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ReflectionPage(ambience: widget.ambience),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);

    // If session is completed, navigate to reflection
    if (playerState.isSessionCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ReflectionPage(ambience: widget.ambience),
          ),
        );
      });
    }

    final bool isAsset = widget.ambience.image.startsWith('assets/');

    return Scaffold(
      body: Stack(
        children: [
          // Calm background visual (Image + Breathing Gradient)
          Positioned.fill(
            child: isAsset 
                ? Image.asset(
                    widget.ambience.image,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    widget.ambience.image,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),
          // Subtle breathing animation
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.2, 1.2),
                  duration: 4.seconds,
                  curve: Curves.easeInOut,
                )
                .fadeIn(duration: 4.seconds),
          ),

          // Player UI
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                // Minimal Back/Minimize Button
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                  ],
                ),
                const Spacer(),
                Text(
                  widget.ambience.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  widget.ambience.tag,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 48),

                // Timer & Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Slider(
                        value: playerState.currentPosition.inSeconds.toDouble(),
                        max: playerState.totalDuration.inSeconds.toDouble(),
                        activeColor: Colors.white,
                        inactiveColor: Colors.white30,
                        onChanged: (value) {
                          ref.read(playerProvider.notifier).seek(Duration(seconds: value.toInt()));
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(playerState.currentPosition),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            _formatDuration(playerState.totalDuration),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 80,
                      icon: Icon(
                        playerState.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        ref.read(playerProvider.notifier).togglePlayPause();
                      },
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: TextButton(
                    onPressed: _onEndSession,
                    child: const Text(
                      'End Session',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
