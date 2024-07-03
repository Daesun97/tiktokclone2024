import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_navigation.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repo.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/inbox/activity_screen.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/chat_screen.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';

import 'package:tiktok_clone/features/videos/view/video_recording_screen.dart';

final routerProvider = Provider((ref) {
  // ref.watch(authState);
  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      //유저가 로그인 됐는가 확인
      final isLogedIn = ref.read(authRepo).isLogedIn;
      //유저가 로그인이 안 돼있는데
      if (!isLogedIn) {
        //가입 화면이나 로그인 화면이 아니라면
        if (state.subloc != SignupScreen.routeUrl &&
            state.subloc != LogInScreen.routeURL) {
          //처음화면으로(가입)
          return SignupScreen.routeUrl;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        name: SignupScreen.routeName,
        path: SignupScreen.routeUrl,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        name: LogInScreen.routeName,
        path: LogInScreen.routeURL,
        builder: (context, state) => const LogInScreen(),
      ),
      GoRoute(
        name: InterestScreen.routeName,
        path: InterestScreen.routeURL,
        builder: (context, state) => const InterestScreen(),
      ),
      GoRoute(
        path: '/:tab(home|discover|inbox|profile)',
        name: MainScreen.routeName,
        builder: (context, state) {
          final tab = state.params['tab']!;
          return MainScreen(
            tab: tab,
          );
        },
      ),
      GoRoute(
        name: ActivityScreen.routeName,
        path: ActivityScreen.routeURL,
        builder: (context, state) => const ActivityScreen(),
      ),
      GoRoute(
          name: ChatsScreen.routeName,
          path: ChatsScreen.routeURL,
          builder: (context, state) => const ChatsScreen(),
          routes: [
            GoRoute(
              name: ChatDetailScreen.routeName,
              path: ChatDetailScreen.routeURL,
              builder: (context, state) {
                final chatId = state.params['chatId']!;
                return ChatDetailScreen(
                  chatId: chatId,
                );
              },
            ),
          ]),
      GoRoute(
        name: VideoRecordingScreen.routeName,
        path: VideoRecordingScreen.routeURL,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const VideoRecordingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final position = Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation);
            return SlideTransition(
              position: position,
              child: child,
            );
          },
        ),
      )
    ],
  );
});
