import 'package:shared_preferences/shared_preferences.dart';
import 'key_value_storage_service.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPrefs();
    switch (T) {
      case const (int):
        return prefs.getInt(key) as T?;
      case const (String):
        return prefs.getString(key) as T?;
      case const (bool):
        return prefs.getBool(key) as T?;

      default:
        throw UnimplementedError(
          "Get no está implementado para el tipo ${T.runtimeType}",
        );
    }
  }

  @override
  Future<Set<String>> getAllKeys() async {
    final prefs = await getSharedPrefs();
    return prefs.getKeys();
  }

  @override
  Future<bool> removeKey(String key) async {
    try {
      final prefs = await getSharedPrefs();
      return await prefs.remove(key);
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();
    switch (T) {
      case const (int):
        prefs.setInt(key, value as int);
        break;
      case const (String):
        prefs.setString(key, value as String);
        break;
      case const (bool):
        prefs.setBool(key, value as bool);
        break;

      default:
        throw UnimplementedError(
          "Set no está implementado para el tipo ${T.runtimeType}",
        );
    }
  }
}
