import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repo.dart';
import 'package:tiktok_clone/features/users/repos/user_repository.dart';
import 'package:tiktok_clone/features/users/view_models/users_vm.dart';

class AvatarViewModel extends AsyncNotifier<void> {
  late final UserRepository _repository;
  @override
  FutureOr<void> build() {
    _repository = ref.read(userRepo);
  }

  Future<void> uploadAvatar(File file) async {
    state = const AsyncValue.loading();
    //파일 이름 만들고
    final fileName = ref.read(authRepo).user!.uid;
    //에러 없으면 파일 Storage에 저장
    state = await AsyncValue.guard(
      () async {
        await _repository.upLoadAvatar(file, fileName);
        await ref.read(usersProvider.notifier).onAvatarUpload();
      },
    );
  }
}

final avataProvider = AsyncNotifierProvider<AvatarViewModel, void>(
  () => AvatarViewModel(),
);
