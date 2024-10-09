import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/core.dart';
import 'package:music_app/features/music/presentation/presentation.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, FavoriteState>((ref) {
  return FavoriteNotifier(
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  );
});

const String musicFavoritePrefix = "music_";
const String namePrefix = "name_";

class FavoriteNotifier extends StateNotifier<FavoriteState> {
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;
  FavoriteNotifier({
    required this.keyValueStorageService,
    required this.ref,
  }) : super(FavoriteState()) {
    _init();
  }

  _init() async {
    // Obtener todas las claves que comienzan con el prefijo "music_"
    Set<String> keysMusics = await keyValueStorageService.getAllKeys();
    List<String> savedMusics =
        keysMusics.where((key) => key.startsWith(musicFavoritePrefix)).toList();

    // Eliminar el prefijo "music_" para obtener solo los identificadores
    Map<String, MusicUtil> savedMusicItems = {};

    for (String key in savedMusics) {
      String musicId = _extractMusicId(key);

      // Obtener la música a partir del ID, buscando en todas las listas
      MusicUtil? music = findMusicById(int.parse(musicId));

      if (music != null) {
        savedMusicItems[musicId] = music;
      }

      state = state.copyWith(savedMusic: savedMusicItems);
    }
  }

  String _extractMusicId(String key) => key.replaceAll(musicFavoritePrefix, '');

  MusicUtil? findMusicById(int id) {
    List<MusicUtil> allMusic = ref.read(musicFolderProvider).playlist;

    try {
      return allMusic.firstWhere((music) => music.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> getIsSaved(String musicId) async {
    try {
      bool isSaved = await keyValueStorageService
              .getValue<bool>("$musicFavoritePrefix$musicId") ??
          false;
      state = state.copyWith(isSaved: isSaved);
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> saveMusic(MusicUtil music) async {
    try {
      bool isSaved = await keyValueStorageService
              .getValue<bool>("$musicFavoritePrefix${music.id}") ??
          false;

      //Toggle
      isSaved = !isSaved;

      final updatedSavedMusic = Map<String, MusicUtil>.from(state.savedMusic);

      if (!isSaved) {
        await keyValueStorageService
            .removeKey("$musicFavoritePrefix${music.id}");

        updatedSavedMusic.remove(music.id.toString());
      } else {
        await keyValueStorageService.setKeyValue<bool>(
            "$musicFavoritePrefix${music.id}", isSaved);

        updatedSavedMusic[music.id.toString()] = music;
      }

      state = state.copyWith(
        isSaved: isSaved,
        savedMusic: updatedSavedMusic,
      );
    } catch (e) {
      throw Exception();
    }
  }
}

class FavoriteState {
  final bool isSaved;
  final Map<String, MusicUtil> savedMusic;

  FavoriteState({
    this.isSaved = false,
    this.savedMusic = const {},
  });

  FavoriteState copyWith({
    bool? isSaved,
    Map<String, MusicUtil>? savedMusic,
  }) =>
      FavoriteState(
        isSaved: isSaved ?? this.isSaved,
        savedMusic: savedMusic ?? this.savedMusic,
      );
}
