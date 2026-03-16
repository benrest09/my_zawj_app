import 'package:flutter/material.dart';
import 'package:zawj_app/widgets/app_color.dart';

class OnboardingIndicator extends StatelessWidget {
  final int currentIndex;
  OnboardingIndicator({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final bool isActive = index == currentIndex;

        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColor.pinktua : AppColor.abutua,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}
