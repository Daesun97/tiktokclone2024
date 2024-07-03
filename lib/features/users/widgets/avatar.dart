import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/features/users/view_models/avatar_vm.dart';

class Avatar extends ConsumerWidget {
  final String name;
  final bool hasAvatar;
  final String uid;
  const Avatar({
    super.key,
    required this.uid,
    required this.hasAvatar,
    required this.name,
  });

  Future<void> _onAvatarTapped(WidgetRef ref) async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (xfile != null) {
      final file = File(xfile.path);
      ref.read(avataProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avataProvider).isLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _onAvatarTapped(ref),
      child: isLoading
          ? Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(),
            )
          : CircleAvatar(
              radius: 50,
              foregroundColor: Colors.blue,
              foregroundImage: hasAvatar
                  ? NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/tiktokclone-dbseotjs.appspot.com/o/avatars%2F$uid?alt=media&trick=${DateTime.now().toString()}')
                  : null,
              child: Text(name),
            ),
    );
  }
}

 //  https://firebasestorage.googleapis.com/v0/b/tiktokclone-dbseotjs.appspot.com/o/avatars%2F?$uid?alt=media
//  https://firebasestorage.googleapis.com/v0/b/tiktokclone-dbseotjs.appspot.com/o/avatars%2FmzaxMCK63UP0ls1W1BaFgt3mQno2?alt=media