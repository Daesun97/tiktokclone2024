import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class FromButton extends StatelessWidget {
  const FromButton({
    super.key,
    required this.disabled,
  });

  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color:
              disabled ? Colors.grey.shade300 : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(Sizes.size8),
        ),
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: Sizes.size16),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: disabled ? Colors.grey.shade400 : Colors.white,
          ),
          child: const Text(
            '다음',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
