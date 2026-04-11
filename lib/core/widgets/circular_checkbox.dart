import 'package:flutter/material.dart';

import '../utils/theme/app_colors.dart';

class CircularCheckbox extends StatelessWidget {
  const CircularCheckbox({
    required this.isChecked,
    required this.onTap,
    super.key,
  });

  final bool isChecked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isChecked ? AppColors.vibrantGreen : AppColors.borderDivider,
        ),
        child: isChecked
            ? const Icon(
                Icons.check,
                size: 18,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}