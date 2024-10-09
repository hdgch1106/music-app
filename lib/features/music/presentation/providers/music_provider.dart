import 'dart:async';
import 'dart:developer';

import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/core/core.dart';

final musicProvider = StateNotifierProvider<MusicNotifier, MusicState>((ref) {
  return MusicNotifier();
});

class MusicNotifier extends StateNotifier<MusicState> {
  bool _isDisposed = false;
  late AudioPlayer _audioPlayer;

  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _currentIndexSubscription;

  MusicNotifier() : super(MusicState()) {
    _audioPlayer = AudioPlayer();
  }

  AudioPlayer get audioPlayer => _audioPlayer;

  void _listenToDuration() {
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      if (!_isDisposed) {
        state = state.copyWith(currentDuration: position);
      }
    });

    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      if (!_isDisposed) {
        state = state.copyWith(totalDuration: duration ?? Duration.zero);
      }
    });

    _playerStateSubscription =
        _audioPlayer.playerStateStream.listen((playerState) {
      if (!_isDisposed) {
        if (playerState.processingState == ProcessingState.completed) {
          onPlayNext();
        }

        // Actualiza el estado de reproducción
        if (playerState.playing) {
          state = state.copyWith(isPlaying: true);
        } else if (!playerState.playing &&
            playerState.processingState != ProcessingState.loading) {
          state = state.copyWith(isPlaying: false);
        }

        // Actualiza el índice de la canción actual
        _updateCurrentSongIndex();
      }
    });
  }

  void _listenToIndex() {
    _currentIndexSubscription = _audioPlayer.currentIndexStream.listen((index) {
      if (!_isDisposed && index != null && index != state.currentSongIndex) {
        state = state.copyWith(currentSongIndex: index);
        //print('Current index updated: $index');
      }
    });
  }

  Future<void> stopAndDispose() async {
    if (_isDisposed) return;

    // Cancela las suscripciones de los streams
    await _positionSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _currentIndexSubscription?.cancel();

    _positionSubscription = null;
    _durationSubscription = null;
    _playerStateSubscription = null;
    _currentIndexSubscription = null;

    await _audioPlayer.dispose();
    _isDisposed = true;
  }

  Future<void> setPlaylist(List<MusicUtil> playlist, int index) async {
    if (!_isDisposed) {
      await stopAndDispose();
    }

    _audioPlayer = AudioPlayer();
    _listenToDuration();
    _listenToIndex();
    _isDisposed = false;

    List<AudioSource> audioSources = playlist.map((music) {
      final uri = Uri.parse('asset://${music.musicPath}');
      return AudioSource.uri(
        uri,
        tag: MediaItem(
          id: music.id.toString(),
          album: music.description,
          title: music.name,
          artUri: Uri.parse(
            'https://png.pngtree.com/background/20210715/original/pngtree-electronic-music-album-picture-image_1301130.jpg',
          ),
        ),
      );
    }).toList();

    final playlistSource = ConcatenatingAudioSource(children: audioSources);
    await _audioPlayer.setAudioSource(playlistSource, initialIndex: index);

    state = state.copyWith(
      playlist: playlist,
      currentSongIndex: index,
    );
    //print(state);
    onPlay();
  }

  void setCurrentSongIndex(int index) {
    if (index >= 0 && index < state.playlist.length) {
      audioPlayer.seek(Duration.zero, index: index);
      state = state.copyWith(currentSongIndex: index);
      onPlay();
    }
  }

  Future<void> onPlay() async {
    if (!state.isPlaying) {
      await _audioPlayer.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  Future<void> onPause() async {
    if (state.isPlaying) {
      await _audioPlayer.pause();
      state = state.copyWith(isPlaying: false);
    }
  }

  Future<void> onResume() async {
    if (!state.isPlaying) {
      await _audioPlayer.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  onPauseOrResume() {
    if (state.isPlaying) {
      onPause();
    } else {
      onResume();
    }
  }

  void onPlayNext() async {
    if (state.isShuffle) {
      if (!_audioPlayer.shuffleModeEnabled) {
        await _audioPlayer.setShuffleModeEnabled(true);
      }

      final shuffleIndices = _audioPlayer.shuffleIndices;
      log('Shuffle indices: $shuffleIndices');
      log('Current index: ${_audioPlayer.currentIndex}');

      if (shuffleIndices != null && shuffleIndices.isNotEmpty) {
        final currentShuffledIndex =
            shuffleIndices.indexOf(_audioPlayer.currentIndex!);

        final nextShuffledIndex =
            (currentShuffledIndex + 1) % shuffleIndices.length;
        final nextIndex = shuffleIndices[nextShuffledIndex];

        log('Next shuffled index: $nextIndex');
        await _audioPlayer.seek(Duration.zero, index: nextIndex);
        state = state.copyWith(currentSongIndex: nextIndex);
      }
    } else {
      if (state.repeatMode == LoopMode.one) {
        await _audioPlayer.seek(Duration.zero);
      } else {
        final nextIndex = (state.currentSongIndex + 1) % state.playlist.length;
        await _audioPlayer.seek(Duration.zero, index: nextIndex);
        state = state.copyWith(currentSongIndex: nextIndex);
      }
    }
    onPlay();
  }

  Future<void> onPlayPrevious() async {
    final previousIndex = (state.currentSongIndex - 1 + state.playlist.length) %
        state.playlist.length;
    await _audioPlayer.seek(Duration.zero, index: previousIndex);
    state = state.copyWith(currentSongIndex: previousIndex);
    onPlay();
  }

  // Método para alternar el modo aleatorio
  void toggleShuffle() {
    bool isShuffling = !state.isShuffle;
    _audioPlayer.setShuffleModeEnabled(isShuffling);
    state = state.copyWith(isShuffle: isShuffling);
    //print('Shuffle mode is now: $isShuffling');
  }

  // Método para alternar entre modos de repetición
  void toggleRepeatMode() async {
    LoopMode nextMode;
    if (state.repeatMode == LoopMode.off) {
      nextMode = LoopMode.all;
    } else if (state.repeatMode == LoopMode.all) {
      nextMode = LoopMode.one;
    } else {
      nextMode = LoopMode.off;
    }
    await _audioPlayer.setLoopMode(nextMode);
    state = state.copyWith(repeatMode: nextMode);
  }

  void _updateCurrentSongIndex() {
    final currentIndex = _audioPlayer.currentIndex ?? state.currentSongIndex;
    if (currentIndex != state.currentSongIndex) {
      state = state.copyWith(currentSongIndex: currentIndex);
      //print('Current index updated: $currentIndex');
    }
  }
}

class MusicState {
  final List<MusicUtil> playlist;
  final int currentSongIndex;
  final Duration currentDuration;
  final Duration totalDuration;
  final bool isPlaying;
  final bool isShuffle;
  final LoopMode repeatMode;
  MusicState({
    this.playlist = const [],
    this.currentSongIndex = 0,
    this.currentDuration = Duration.zero,
    this.totalDuration = Duration.zero,
    this.isPlaying = false,
    this.isShuffle = false,
    this.repeatMode = LoopMode.off,
  });

  MusicState copyWith({
    List<MusicUtil>? playlist,
    int? currentSongIndex,
    Duration? currentDuration,
    Duration? totalDuration,
    bool? isPlaying,
    bool? isShuffle,
    LoopMode? repeatMode,
  }) =>
      MusicState(
        playlist: playlist ?? this.playlist,
        currentSongIndex: currentSongIndex ?? this.currentSongIndex,
        currentDuration: currentDuration ?? this.currentDuration,
        totalDuration: totalDuration ?? this.totalDuration,
        isPlaying: isPlaying ?? this.isPlaying,
        isShuffle: isShuffle ?? this.isShuffle,
        repeatMode: repeatMode ?? this.repeatMode,
      );
}
