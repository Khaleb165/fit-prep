import 'package:flutter/material.dart';

import '../constants/size_config.dart';
import '../theme/app_colors.dart';

class ReminderPeriodSelector extends StatelessWidget {
  const ReminderPeriodSelector({
    required this.periods,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<String> periods;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: List<Widget>.generate(periods.length, (index) {
          final bool isSelected = index == selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.deepBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  periods[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(14),
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}