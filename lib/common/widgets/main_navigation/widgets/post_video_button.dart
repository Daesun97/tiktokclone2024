import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class PostVideoButton extends StatelessWidget {
  const PostVideoButton({super.key, required this.inverted});

  final bool inverted;

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: 30,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size8),
            height: 40,
            width: 25,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(
                Sizes.size8,
              ),
            ),
          ),
        ),
        Positioned(
          left: 30,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size8),
            height: 40,
            width: 25,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(
                Sizes.size8,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: !inverted || isDark ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(Sizes.size6)),
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size16),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: !inverted || isDark ? Colors.black : Colors.white,
              size: Sizes.size20,
            ),
          ),
        ),
      ],
    );
  }
}
