import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/utils.dart';

class NAvTab extends StatelessWidget {
  const NAvTab(
      {super.key,
      required this.text,
      required this.isSelected,
      required this.icon,
      required this.onTap,
      required this.selectedIcon,
      required this.selectedIndex});

  final String text;
  final bool isSelected;
  final IconData icon;
  final IconData selectedIcon;
  final int selectedIndex;

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Expanded(
      child: InkWell(
        onTap: () => onTap(),
        child: Container(
          color: selectedIndex == 0 || isDark ? Colors.black : Colors.white,
          child: AnimatedOpacity(
            opacity: isSelected ? 1 : 0.6,
            duration: const Duration(milliseconds: 250),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  isSelected ? selectedIcon : icon,
                  color: selectedIndex == 0 || isDark
                      ? Colors.white
                      : Colors.black,
                ),
                Gaps.v5,
                Text(
                  text,
                  style: TextStyle(
                    color: selectedIndex == 0 || isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
