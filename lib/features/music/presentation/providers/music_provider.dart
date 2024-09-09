import 'dart:developer' as dev;
import 'dart:math';

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
        dev.log('Exception in stopAndDispose: $e');
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
    if (state.isShuffle) {
      if (state.playlist.isNotEmpty) {
        if (state.playlist.length == 1) {
          state = state.copyWith(currentSongIndex: 0);
        } else {
          int nextIndex;
          do {
            nextIndex = Random().nextInt(state.playlist.length);
          } while (nextIndex == state.currentSongIndex);
          state = state.copyWith(currentSongIndex: nextIndex);
        }
      }
    } else {
      if (state.currentSongIndex < state.playlist.length - 1 &&
          state.repeatMode != RepeatMode.repeatOne) {
        // Reproducir la siguiente canción si no estás al final de la lista y no en modo repeatOne
        state = state.copyWith(currentSongIndex: state.currentSongIndex + 1);
      } else if (state.currentSongIndex >= state.playlist.length - 1) {
        // Manejar el final de la lista
        if (state.repeatMode == RepeatMode.repeatAll) {
          // Repetir todas las canciones
          state = state.copyWith(currentSongIndex: 0);
        } else if (state.repeatMode == RepeatMode.repeatOne) {
          // Repetir la misma canción: No cambiar el índice de la canción actual
          state = state.copyWith(currentSongIndex: state.currentSongIndex);
        }
      }
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

  void toggleShuffle() {
    state = state.copyWith(isShuffle: !state.isShuffle);
  }

  void toggleRepeat() {
    RepeatMode nextMode;

    switch (state.repeatMode) {
      case RepeatMode.none:
        nextMode = RepeatMode.repeatAll;
        break;
      case RepeatMode.repeatAll:
        nextMode = RepeatMode.repeatOne;
        break;
      case RepeatMode.repeatOne:
        nextMode = RepeatMode.none;
        break;
    }

    state = state.copyWith(repeatMode: nextMode);
  }
}

enum RepeatMode { none, repeatAll, repeatOne }

class MusicState {
  final List<MusicUtil> playlist;
  final int currentSongIndex;
  final AudioPlayer? audioPlayer;
  final Duration currentDuration;
  final Duration totalDuration;
  final bool isPlaying;
  final bool isShuffle;
  final bool isRepeat;
  final RepeatMode repeatMode;
  MusicState({
    this.playlist = const [],
    this.currentSongIndex = 0,
    this.audioPlayer,
    this.currentDuration = Duration.zero,
    this.totalDuration = Duration.zero,
    this.isPlaying = false,
    this.isShuffle = false,
    this.isRepeat = false,
    this.repeatMode = RepeatMode.none,
  });

  MusicState copyWith({
    List<MusicUtil>? playlist,
    int? currentSongIndex,
    AudioPlayer? audioPlayer,
    Duration? currentDuration,
    Duration? totalDuration,
    bool? isPlaying,
    bool? isShuffle,
    bool? isRepeat,
    RepeatMode? repeatMode,
  }) =>
      MusicState(
        playlist: playlist ?? this.playlist,
        currentSongIndex: currentSongIndex ?? this.currentSongIndex,
        audioPlayer: audioPlayer ?? this.audioPlayer,
        currentDuration: currentDuration ?? this.currentDuration,
        totalDuration: totalDuration ?? this.totalDuration,
        isPlaying: isPlaying ?? this.isPlaying,
        isShuffle: isShuffle ?? this.isShuffle,
        isRepeat: isRepeat ?? this.isRepeat,
        repeatMode: repeatMode ?? this.repeatMode,
      );
}
