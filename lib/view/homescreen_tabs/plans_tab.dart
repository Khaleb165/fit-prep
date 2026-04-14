import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/size_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/delete_background.dart';
import '../plan_detail_page.dart';
import '../../view_model/plan_provider.dart';

class PlansTab extends StatelessWidget {
  const PlansTab({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    final plans = context.watch<PlanProvider>().plans;

    if (plans.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Your workout plans will show up here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: getProportionateScreenHeight(18),
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      itemCount: plans.length,
      separatorBuilder: (_, __) =>
          SizedBox(height: getProportionateScreenHeight(14)),
      itemBuilder: (context, index) {
        final plan = plans[index];

        return Dismissible(
          key: ValueKey(plan.id),
          direction: DismissDirection.horizontal,
          background: const DeleteBackground(
            alignment: Alignment.centerLeft,
          ),
          secondaryBackground: const DeleteBackground(
            alignment: Alignment.centerRight,
          ),
          onDismissed: (_) async {
            await context.read<PlanProvider>().deletePlan(plan.id);

            if (!context.mounted) {
              return;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${plan.title} deleted.'),
              ),
            );
          },
          child: SizedBox(
            width: double.infinity,
            child: Material(
              color: AppColors.cardWhite,
              elevation: 2,
              shadowColor: AppColors.textSecondary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlanDetailPage(plan: plan),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.title,
                        style: TextStyle(
                          fontSize: getProportionateScreenHeight(18),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      Text(
                        '${plan.reminderSettings.periodLabel} • ${plan.reminderSettings.formatTime(context)}',
                        style: TextStyle(
                          fontSize: getProportionateScreenHeight(14),
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(6)),
                      Text(
                        '${plan.items.length} items • Reminder ${plan.reminderSettings.reminderLabel}',
                        style: TextStyle(
                          fontSize: getProportionateScreenHeight(13),
                          color: AppColors.deepBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
