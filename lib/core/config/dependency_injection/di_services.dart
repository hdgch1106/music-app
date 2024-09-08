import 'package:get_it/get_it.dart';
import 'package:music_app/core/core.dart';

void injectServices() {
  GetIt.I.registerLazySingleton<KeyValueStorageService>(
    () => KeyValueStorageServiceImpl(),
  );
}

class DIServices {
  DIServices._();

  static KeyValueStorageService get keyValueStorageService =>
      GetIt.I.get<KeyValueStorageService>();
}
