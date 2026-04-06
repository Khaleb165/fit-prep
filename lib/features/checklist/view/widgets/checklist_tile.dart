import 'package:flutter/material.dart';

import '../../../../core/constants/size_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/circular_checkbox.dart';

class ChecklistTile extends StatelessWidget {
  const ChecklistTile({
    required this.title,
    required this.isChecked,
    required this.onToggle,
    required this.onTap,
    super.key,
  });

  final String title;
  final bool isChecked;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircularCheckbox(
          isChecked: isChecked,
          onTap: onToggle,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: getProportionateScreenHeight(16),
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: CircularCheckbox(
          isChecked: isChecked,
          onTap: onToggle,
        ),
        onTap: onTap,
      ),
    );
  }
}
