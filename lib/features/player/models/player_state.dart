import 'package:lock_in/features/ambience/models/ambience_model.dart';

class SessionPlayerState {
  final Ambience? currentAmbience;
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final bool isSessionCompleted;

  SessionPlayerState({
    this.currentAmbience,
    this.isPlaying = false,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.isSessionCompleted = false,
  });

  SessionPlayerState copyWith({
    Ambience? currentAmbience,
    bool? isPlaying,
    Duration? currentPosition,
    Duration? totalDuration,
    bool? isSessionCompleted,
  }) {
    return SessionPlayerState(
      currentAmbience: currentAmbience ?? this.currentAmbience,
      isPlaying: isPlaying ?? this.isPlaying,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      isSessionCompleted: isSessionCompleted ?? this.isSessionCompleted,
    );
  }
}
