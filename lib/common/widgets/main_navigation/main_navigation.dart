import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/user_porfile_screen.dart';
import 'package:tiktok_clone/features/discover/discover_screen.dart';
import 'package:tiktok_clone/features/inbox/inbox_screen.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/widgets/nav_tab.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/widgets/post_video_button.dart';
import 'package:tiktok_clone/features/videos/view/video_recording_screen.dart';
import 'package:tiktok_clone/features/videos/view/videos_timeline_screen.dart';
import 'package:tiktok_clone/utils.dart';

class MainScreen extends StatefulWidget {
  static String routeName = 'MainNavigation';

  final String tab;
  const MainScreen({super.key, required this.tab});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<String> _tabs = [
    'home',
    'discover',
    'video',
    'inbox',
    'profile',
  ];
  late int _selectedIndex = _tabs.indexOf(widget.tab);

  void _onTap(int index) {
    context.go('/${_tabs[index]}');
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onPostVideoButtonTap() {
    context.pushNamed(VideoRecordingScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Scaffold(
      //밑에서 뭐가 튀어나와도(키보드 같은거) 화면에 영향을 안주게 함
      resizeToAvoidBottomInset: false,
      backgroundColor:
          _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const VideoTimelineScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: const DiscoverScreen(),
          ),
          Offstage(offstage: _selectedIndex != 3, child: const InboxScreen()),
          Offstage(
              offstage: _selectedIndex != 4,
              child: const UserProfileScreen(
                tab: '',
                username: '',
              )),
        ],
      ),
      bottomNavigationBar: Container(
        color: _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size1, vertical: Sizes.size12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NAvTab(
                  text: 'Home',
                  isSelected: _selectedIndex == 0,
                  selectedIcon: FontAwesomeIcons.house,
                  icon: FontAwesomeIcons.house,
                  onTap: () => _onTap(0),
                  selectedIndex: _selectedIndex),
              NAvTab(
                  text: 'Discover',
                  isSelected: _selectedIndex == 1,
                  selectedIcon: FontAwesomeIcons.solidCompass,
                  icon: FontAwesomeIcons.compass,
                  onTap: () => _onTap(1),
                  selectedIndex: _selectedIndex),
              Gaps.h20,
              GestureDetector(
                onTap: _onPostVideoButtonTap,
                child: PostVideoButton(
                  inverted: _selectedIndex != 0,
                ),
              ),
              Gaps.h20,
              NAvTab(
                  text: 'inbox',
                  isSelected: _selectedIndex == 3,
                  selectedIcon: FontAwesomeIcons.solidMessage,
                  icon: FontAwesomeIcons.message,
                  onTap: () => _onTap(3),
                  selectedIndex: _selectedIndex),
              NAvTab(
                  text: 'Profile',
                  isSelected: _selectedIndex == 4,
                  selectedIcon: FontAwesomeIcons.solidUser,
                  icon: FontAwesomeIcons.user,
                  onTap: () => _onTap(4),
                  selectedIndex: _selectedIndex),
            ],
          ),
        ),
      ),
    );
  }
}
