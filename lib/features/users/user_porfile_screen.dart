import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/view_models/users_vm.dart';
import 'package:tiktok_clone/features/users/widgets/avatar.dart';
import 'package:tiktok_clone/features/users/widgets/persistent_Tab_Bar.dart';
import 'package:tiktok_clone/features/setting/settings_screen.dart';
import 'package:tiktok_clone/utils.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String username;
  final String tab;
  const UserProfileScreen(
      {super.key, required this.username, required this.tab});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  void _onGearPlessed() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SettingScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(
              error.toString(),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Scaffold(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            body: SafeArea(
              child: DefaultTabController(
                initialIndex: widget.tab == 'likes' ? 1 : 0,
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        centerTitle: true,
                        title: Text(
                          data.name,
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black),
                        ),
                        actions: [
                          IconButton(
                              onPressed: _onGearPlessed,
                              icon: const FaIcon(
                                FontAwesomeIcons.gear,
                                size: Sizes.size20,
                              ))
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Gaps.v20,
                            Avatar(
                              name: data.name,
                              hasAvatar: data.hasAvatar,
                              uid: data.uid,
                            ),
                            Gaps.v10,
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '@${data.name}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: Sizes.size20),
                                    ),
                                    Gaps.h5,
                                    const Icon(Icons.check_circle)
                                  ],
                                ),
                                Gaps.v20,
                                const SizedBox(
                                  height: Sizes.size52,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            '90',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: Sizes.size16),
                                          ),
                                          Gaps.v2,
                                          Text(
                                            'Following',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                      VerticalDivider(
                                        indent: 10,
                                        endIndent: 10,
                                        width: 30,
                                        thickness: 1,
                                        color: Colors.black,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            '40',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: Sizes.size16),
                                          ),
                                          Gaps.v2,
                                          Text(
                                            'Follower',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                      VerticalDivider(
                                        indent: 10,
                                        endIndent: 10,
                                        width: 30,
                                        thickness: 1,
                                        color: Colors.black,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            '9000',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: Sizes.size16),
                                          ),
                                          Gaps.v2,
                                          Text(
                                            'Likes',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Gaps.v16,
                                FractionallySizedBox(
                                  widthFactor: 0.33,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Sizes.size12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(
                                        Sizes.size4,
                                      ),
                                    ),
                                    child: const Text(
                                      textAlign: TextAlign.center,
                                      "Follow",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Gaps.v14,
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Sizes.size32),
                                  child: Text(
                                    '해당 체널 설명 좀 길게 적어도됨',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Gaps.v14,
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.link,
                                      size: Sizes.size12,
                                    ),
                                    Gaps.h4,
                                    Text(
                                      '유튜브나 블로그 Url',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Gaps.v10,
                              ],
                            ),
                          ],
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: PersistentTabBar(),
                        pinned: true,
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: 20,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: Sizes.size3,
                                mainAxisSpacing: Sizes.size3,
                                childAspectRatio: 9 / 14),
                        itemBuilder: (context, index) => Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 9 / 14,
                              child: FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  placeholder: 'assets/cat.jpg',
                                  image:
                                      'https://img2.daumcdn.net/thumb/R658x0.q70/?fname=https://t1.daumcdn.net/news/202105/25/holapet/20210525071226651wwqg.jpg'),
                            ),
                          ],
                        ),
                      ),
                      const Center(
                        child: Text('페이지 2'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
