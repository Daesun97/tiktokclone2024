import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_clone/common/widgets/video_config.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/viewmodel/playback_config_vm.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Setting',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView(
          children: [
            SwitchListTile.adaptive(
                value: ref.watch(playbackConfigProvider).muted,
                onChanged: (value) =>
                    {ref.read(playbackConfigProvider.notifier).setMuted(value)},
                title: const Text('동영상 음소거')),
            SwitchListTile.adaptive(
                value: ref.watch(playbackConfigProvider).autoplay,
                onChanged: (value) => {
                      ref
                          .read(playbackConfigProvider.notifier)
                          .setAutoplay(value)
                    },
                title: const Text('동영상 자동재생')),
            CheckboxListTile(
              value: false,
              onChanged: (value) {},
              title: const Text('알림설정'),
            ),
            ListTile(
              onTap: () => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now()),
              title: const Text(
                '생일',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('About this app......'),
            ),
            ListTile(
              title: const Text('Log Out (Ios)'),
              textColor: Colors.red,
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('진짜로?'),
                    content: const Text('가지마잇'),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('No'),
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          ref.read(authRepo).signOut();
                          context.go('/');
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Log Out (Android)'),
              textColor: Colors.red,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('진짜로?'),
                    content: const Text('가지마잇'),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('No'),
                      ),
                      CupertinoDialogAction(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Log Out (Ios / Buttom)'),
              textColor: Colors.red,
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    title: const Text('진짜로?'),
                    actions: [
                      CupertinoActionSheetAction(
                          onPressed: () {}, child: const Text('안나감')),
                      CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () {},
                          child: const Text('나감'))
                    ],
                  ),
                );
              },
            ),
            const AboutListTile()
          ],
        ));
  }
}
