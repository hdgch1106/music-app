import 'dart:io';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/core.dart';

final musicFolderProvider =
    StateNotifierProvider<MusicFolderNotifier, MusicFolderState>((ref) {
  return MusicFolderNotifier(
    filePickerService: DIServices.filePickerService,
    keyValueStorageService: DIServices.keyValueStorageService,
  );
});

class MusicFolderNotifier extends StateNotifier<MusicFolderState> {
  final FilePickerService filePickerService;
  final KeyValueStorageService keyValueStorageService;
  MusicFolderNotifier({
    required this.filePickerService,
    required this.keyValueStorageService,
  }) : super(MusicFolderState()) {
    _getMusicFolder();
  }

  Future<void> _getMusicFolder() async {
    final pathFolder =
        await keyValueStorageService.getValue<String>("pathFolder");
    if (pathFolder == null) return;
    await _findMusicInFolder(pathFolder);
    state = state.copyWith(pathFolder: pathFolder);
  }

  Future<void> setMusicFolder() async {
    final pathFolder = await filePickerService.getDirectoryPath();
    if (pathFolder == null) return;
    await _findMusicInFolder(pathFolder);
    await keyValueStorageService.setKeyValue<String>("pathFolder", pathFolder);
    state = state.copyWith(pathFolder: pathFolder);
  }

  Future<void> _findMusicInFolder(String pathFolder) async {
    final directory = Directory(pathFolder);
    final files = directory.listSync();

    List<MusicUtil> playlist = [];

    for (var file in files) {
      if (file.path.endsWith(".mp3") || file.path.endsWith(".m4a")) {
        final music = MusicUtil(
          id: file.path.hashCode,
          name: _getFileName(file.path),
          description: "Archivo de música",
          imagePath: "assets/imgs/music_5.jpg",
          musicPath: file.path,
        );
        playlist.add(music);
      }
    }

    // Mezcla la lista de canciones para obtener una selección aleatoria solo para la specialPlaylist
    List<MusicUtil> specialPlaylist =
        List.from(playlist); // Crea una copia de la playlist
    specialPlaylist.shuffle(Random()); // Mezcla la copia

    // Selecciona las primeras 10 canciones (si hay al menos 10) de la specialPlaylist
    specialPlaylist = specialPlaylist.length > 10
        ? specialPlaylist.sublist(0, 10)
        : specialPlaylist;

    // Actualiza el estado con la playlist completa y la specialPlaylist
    state = state.copyWith(
      playlist: playlist, // La playlist general permanece sin mezclar
      specialPlaylist: specialPlaylist, // La specialPlaylist es aleatoria
    );
  }

  String _getFileName(String filePath) {
    String fileName = filePath.split('/').last;
    return fileName.replaceAll(RegExp(r'\.(mp3|m4a)$'), '');
  }
}

class MusicFolderState {
  final List<MusicUtil> playlist;
  final List<MusicUtil> specialPlaylist;
  final String pathFolder;

  MusicFolderState({
    this.playlist = const [],
    this.specialPlaylist = const [],
    this.pathFolder = "",
  });

  MusicFolderState copyWith({
    List<MusicUtil>? playlist,
    List<MusicUtil>? specialPlaylist,
    String? pathFolder,
  }) =>
      MusicFolderState(
        playlist: playlist ?? this.playlist,
        specialPlaylist: specialPlaylist ?? this.specialPlaylist,
        pathFolder: pathFolder ?? this.pathFolder,
      );
}
