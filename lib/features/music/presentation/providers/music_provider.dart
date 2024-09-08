import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/core.dart';

final musicProvider = StateNotifierProvider<MusicNotifier, MusicState>((ref) {
  return MusicNotifier();
});

class MusicNotifier extends StateNotifier<MusicState> {
  bool _isDisposed = false;
  MusicNotifier() : super(MusicState());

  _listenToDuration() {
    state = state.copyWith(
      audioPlayer: AudioPlayer(),
    );
    //Listen for total duration
    state.audioPlayer!.onDurationChanged.listen((duration) {
      state = state.copyWith(totalDuration: duration);
    });
    //Listen for current duration
    state.audioPlayer!.onPositionChanged.listen((duration) {
      state = state.copyWith(currentDuration: duration);
    });
    //Listen for song completion
    state.audioPlayer!.onPlayerComplete.listen((event) {
      onPlayNext();
    });
  }

  Future<void> stopAndDispose() async {
    if (_isDisposed) return;

    if (state.audioPlayer != null) {
      try {
        if (state.isPlaying) {
          await state.audioPlayer!.stop();
        }

        await state.audioPlayer!.dispose();
      } catch (e) {
        // Handle exception
        log('Exception in stopAndDispose: $e');
      }

      _isDisposed = true;
    }

    state = state.copyWith(audioPlayer: null, isPlaying: false);
  }

  setPlaylist(List<MusicUtil> playlist, int index) {
    _isDisposed = false;
    _listenToDuration();
    state = state.copyWith(
      playlist: playlist,
      currentSongIndex: index,
    );
    setCurrentSongIndex(index);
  }

  setCurrentSongIndex(int? index) {
    state = state.copyWith(currentSongIndex: index);
    if (index != null) {
      onPlay();
    }
  }

  onPlay() async {
    final String path = state.playlist[state.currentSongIndex].musicPath;
    await state.audioPlayer!.stop();
    await state.audioPlayer!.play(AssetSource(path));
    state = state.copyWith(isPlaying: true);
  }

  onPause() async {
    await state.audioPlayer!.pause();
    state = state.copyWith(isPlaying: false);
  }

  onResume() async {
    await state.audioPlayer!.resume();
    state = state.copyWith(isPlaying: true);
  }

  onPauseOrResume() {
    if (state.isPlaying) {
      onPause();
    } else {
      onResume();
    }
  }

  onSeek(Duration position) async {
    await state.audioPlayer!.seek(position);
  }

  onPlayNext() {
    if (state.currentSongIndex < state.playlist.length - 1) {
      state = state.copyWith(currentSongIndex: state.currentSongIndex + 1);
    } else {
      state = state.copyWith(currentSongIndex: 0);
    }
    onPlay();
  }

  onPlayPrevious() async {
    if (state.currentDuration.inSeconds > 2) {
      await onSeek(Duration.zero);
    } else {
      await state.audioPlayer!.stop();

      if (state.currentSongIndex > 0) {
        state = state.copyWith(currentSongIndex: state.currentSongIndex - 1);
      } else {
        state = state.copyWith(currentSongIndex: state.playlist.length - 1);
      }

      final String path = state.playlist[state.currentSongIndex].musicPath;

      await state.audioPlayer!.play(AssetSource(path));
    }

    state = state.copyWith(isPlaying: true);
  }
}

class MusicState {
  final List<MusicUtil> playlist;
  final int currentSongIndex;
  final AudioPlayer? audioPlayer;
  final Duration currentDuration;
  final Duration totalDuration;
  final bool isPlaying;
  MusicState({
    this.playlist = const [],
    this.currentSongIndex = 0,
    this.audioPlayer,
    this.currentDuration = Duration.zero,
    this.totalDuration = Duration.zero,
    this.isPlaying = false,
  });

  MusicState copyWith({
    List<MusicUtil>? playlist,
    int? currentSongIndex,
    AudioPlayer? audioPlayer,
    Duration? currentDuration,
    Duration? totalDuration,
    bool? isPlaying,
  }) =>
      MusicState(
        playlist: playlist ?? this.playlist,
        currentSongIndex: currentSongIndex ?? this.currentSongIndex,
        audioPlayer: audioPlayer ?? this.audioPlayer,
        currentDuration: currentDuration ?? this.currentDuration,
        totalDuration: totalDuration ?? this.totalDuration,
        isPlaying: isPlaying ?? this.isPlaying,
      );
}
