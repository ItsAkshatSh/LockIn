import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lock_in/features/ambience/models/ambience_model.dart';
import 'package:lock_in/features/player/models/player_state.dart';
import 'package:lock_in/features/analytics/providers/analytics_provider.dart';

final playerProvider = StateNotifierProvider<PlayerNotifier, SessionPlayerState>((ref) {
  final analyticsService = ref.watch(analyticsNotifierProvider);
  return PlayerNotifier(analyticsService);
});

class PlayerNotifier extends StateNotifier<SessionPlayerState> {
  final AnalyticsService _analytics;
  PlayerNotifier(this._analytics) : super(SessionPlayerState());

  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;
  bool _wasPlayingBeforePause = false;

  Future<void> startSession(Ambience ambience) async {
    if (state.currentAmbience?.id != ambience.id) {
       await _audioPlayer.stop();
       state = SessionPlayerState(
        currentAmbience: ambience,
        isPlaying: true,
        currentPosition: Duration.zero,
        totalDuration: Duration(seconds: ambience.duration),
      );
      
      _analytics.logEvent('session_start', metadata: {'ambience': ambience.title});

      try {
        await _audioPlayer.setAsset('assets/music/${ambience.audio}');
        await _audioPlayer.setLoopMode(LoopMode.one);
        _audioPlayer.play();
      } catch (e) {
        debugPrint('Error loading audio: $e');
      }
    } else {
      state = state.copyWith(isPlaying: true);
      _audioPlayer.play();
    }
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isPlaying) return;

      final nextPosition = state.currentPosition + const Duration(seconds: 1);
      if (nextPosition >= state.totalDuration) {
        completeSession();
      } else {
        state = state.copyWith(currentPosition: nextPosition);
      }
    });
  }

  void togglePlayPause() {
    if (state.isPlaying) {
      _audioPlayer.pause();
      state = state.copyWith(isPlaying: false);
      _analytics.logEvent('session_pause');
    } else {
      _audioPlayer.play();
      state = state.copyWith(isPlaying: true);
      _analytics.logEvent('session_resume');
    }
  }

  void handleLifecycleChange(AppLifecycleState lifecycleState) {
    if (state.currentAmbience == null || state.isSessionCompleted) return;

    if (lifecycleState == AppLifecycleState.paused || 
        lifecycleState == AppLifecycleState.inactive) {
      _wasPlayingBeforePause = state.isPlaying;
      if (state.isPlaying) {
        _audioPlayer.pause();
        state = state.copyWith(isPlaying: false);
        _analytics.logEvent('session_background_paused');
      }
    } else if (lifecycleState == AppLifecycleState.resumed) {
      if (_wasPlayingBeforePause) {
        _audioPlayer.play();
        state = state.copyWith(isPlaying: true);
        _analytics.logEvent('session_background_resumed');
      }
    }
  }

  void completeSession() {
    _timer?.cancel();
    _audioPlayer.stop();
    
    _analytics.logEvent('session_end', metadata: {
      'status': 'completed',
      'ambience': state.currentAmbience?.title ?? 'Unknown',
      'duration': state.currentPosition.inSeconds
    });

    state = state.copyWith(
      isPlaying: false,
      isSessionCompleted: true,
      currentPosition: state.totalDuration,
    );
  }

  void endSessionManually() {
    _timer?.cancel();
    _audioPlayer.stop();

    _analytics.logEvent('session_end', metadata: {
      'status': 'manual_quit',
      'ambience': state.currentAmbience?.title ?? 'Unknown',
      'last_position': state.currentPosition.inSeconds
    });

    state = state.copyWith(
      isPlaying: false,
      isSessionCompleted: true,
    );
  }

  void resetSession() {
    state = SessionPlayerState();
    _audioPlayer.stop();
  }

  void seek(Duration position) {
    if (position >= state.totalDuration) {
      completeSession();
    } else {
      state = state.copyWith(currentPosition: position);
      _audioPlayer.seek(position);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
