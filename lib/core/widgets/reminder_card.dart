import 'package:flutter/material.dart';

import '../../model/workout_plan.dart';
import '../constants/size_config.dart';
import '../theme/app_colors.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    required this.plan,
    required this.onTap,
    super.key,
  });

  final WorkoutPlan plan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardWhite,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Reminder details',
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(16),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.edit_outlined,
                    color: AppColors.deepBlue,
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(12)),
              Text(
                'Session: ${plan.reminderSettings.periodLabel}',
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(14),
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                'Workout time: ${plan.reminderSettings.timeLabel}',
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(14),
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                'Reminder: ${plan.reminderSettings.reminderLabel}',
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(14),
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
