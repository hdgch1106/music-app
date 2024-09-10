import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/core.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(
    keyValueStorageService: DIServices.keyValueStorageService,
  );
});

class UserNotifier extends StateNotifier<UserState> {
  final KeyValueStorageService keyValueStorageService;

  UserNotifier({
    required this.keyValueStorageService,
  }) : super(UserState()) {
    _init();
  }

  _init() async {
    final fullName = await keyValueStorageService.getValue<String>('fullName');
    final followers = await keyValueStorageService.getValue<int>('followers');
    final following = await keyValueStorageService.getValue<int>('following');

    state = state.copyWith(
      fullName: fullName ?? state.fullName,
      followers: followers ?? state.followers,
      following: following ?? state.following,
    );
  }

  Future<void> setFullName(String fullName) async {
    await keyValueStorageService.setKeyValue<String>('fullName', fullName);
    state = state.copyWith(fullName: fullName);
  }

  Future<void> setFollowers(int followers) async {
    await keyValueStorageService.setKeyValue<int>('followers', followers);
    state = state.copyWith(followers: followers);
  }

  Future<void> setFollowing(int following) async {
    await keyValueStorageService.setKeyValue<int>('following', following);
    state = state.copyWith(following: following);
  }
}

class UserState {
  final String fullName;
  final int followers;
  final int following;
  UserState({
    this.fullName = 'Hugo Grados',
    this.followers = 25,
    this.following = 58,
  });

  UserState copyWith({
    String? fullName,
    int? followers,
    int? following,
  }) {
    return UserState(
      fullName: fullName ?? this.fullName,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}
