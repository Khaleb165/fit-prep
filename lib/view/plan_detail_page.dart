import 'package:flutter/material.dart';

import '../core/constants/size_config.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/gradient_logo_app_bar.dart';
import '../model/workout_plan.dart';

class PlanDetailPage extends StatelessWidget {
  const PlanDetailPage({
    required this.plan,
    super.key,
  });

  final WorkoutPlan plan;

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);

    return Scaffold(
      appBar: const GradientLogoAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundLightGrey,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.title,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(24),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                _PlanInfoCard(
                  title: 'Reminder details',
                  lines: [
                    'Session: ${plan.reminderSettings.periodLabel}',
                    'Workout time: ${plan.reminderSettings.timeLabel}',
                    'Reminder: ${plan.reminderSettings.reminderLabel}',
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(18)),
                _PlanInfoCard(
                  title: 'Checklist items',
                  lines: plan.items.map((item) => item.title).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanInfoCard extends StatelessWidget {
  const _PlanInfoCard({
    required this.title,
    required this.lines,
  });

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: getProportionateScreenHeight(16),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(12)),
          ...lines.map(
            (line) => Padding(
              padding: EdgeInsets.only(
                bottom: getProportionateScreenHeight(10),
              ),
              child: Text(
                line,
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(14),
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
