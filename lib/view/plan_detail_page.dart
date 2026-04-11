import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/size_config.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/utils.dart';
import '../core/widgets/checklist_tile.dart';
import '../core/widgets/delete_background.dart';
import '../core/widgets/gradient_logo_app_bar.dart';
import '../core/widgets/reminder_card.dart';
import '../model/reminder_settings.dart';
import '../model/workout_plan.dart';
import '../view_model/plan_provider.dart';

class PlanDetailPage extends StatelessWidget {
  const PlanDetailPage({
    required this.plan,
    super.key,
  });

  final WorkoutPlan plan;

  Future<void> _showReminderDialog(
    BuildContext context,
    WorkoutPlan plan,
  ) async {
    int selectedPeriodIndex = plan.reminderSettings.selectedPeriodIndex;
    int selectedHourIndex = plan.reminderSettings.selectedHourIndex;
    int selectedMinuteIndex = plan.reminderSettings.selectedMinuteIndex;
    int selectedMeridiemIndex = plan.reminderSettings.selectedMeridiemIndex;
    bool remindBefore = plan.reminderSettings.remindBefore;

    final ReminderSettings? updatedSettings =
        await showDialog<ReminderSettings>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit reminder'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<int>(
                      value: selectedPeriodIndex,
                      decoration: const InputDecoration(
                        labelText: 'Session period',
                      ),
                      items: List<DropdownMenuItem<int>>.generate(
                        periods.length,
                        (index) => DropdownMenuItem<int>(
                          value: index,
                          child: Text(periods[index]),
                        ),
                      ),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          selectedPeriodIndex = value;
                        });
                      },
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: selectedHourIndex,
                            decoration: const InputDecoration(
                              labelText: 'Hour',
                            ),
                            items: List<DropdownMenuItem<int>>.generate(
                              12,
                              (index) => DropdownMenuItem<int>(
                                value: index,
                                child: Text('${index + 1}'),
                              ),
                            ),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                selectedHourIndex = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: getProportionateScreenHeight(10)),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: selectedMinuteIndex,
                            decoration: const InputDecoration(
                              labelText: 'Minute',
                            ),
                            items: List<DropdownMenuItem<int>>.generate(
                              minutes.length,
                              (index) => DropdownMenuItem<int>(
                                value: index,
                                child: Text(minutes[index]),
                              ),
                            ),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                selectedMinuteIndex = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: getProportionateScreenHeight(10)),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: selectedMeridiemIndex,
                            decoration: const InputDecoration(
                              labelText: 'AM/PM',
                            ),
                            items: const [
                              DropdownMenuItem<int>(
                                value: 0,
                                child: Text('AM'),
                              ),
                              DropdownMenuItem<int>(
                                value: 1,
                                child: Text('PM'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                selectedMeridiemIndex = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Reminder: 1 hour before'),
                      value: remindBefore,
                      onChanged: (value) {
                        setState(() {
                          remindBefore = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      ReminderSettings(
                        selectedPeriodIndex: selectedPeriodIndex,
                        selectedHourIndex: selectedHourIndex,
                        selectedMinuteIndex: selectedMinuteIndex,
                        selectedMeridiemIndex: selectedMeridiemIndex,
                        remindBefore: remindBefore,
                      ),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (updatedSettings == null) {
      return;
    }

    await context.read<PlanProvider>().updatePlanReminder(
          plan.id,
          updatedSettings,
        );
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    final WorkoutPlan? currentPlan =
        context.watch<PlanProvider>().getPlanById(plan.id);

    if (currentPlan == null) {
      return Scaffold(
        appBar: const GradientLogoAppBar(),
        body: Container(
          color: AppColors.backgroundLightGrey,
          alignment: Alignment.center,
          child: const Text(
            'This plan is no longer available.',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

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
                  currentPlan.title,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(24),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                ReminderCard(
                  plan: currentPlan,
                  onTap: () => _showReminderDialog(context, currentPlan),
                ),
                SizedBox(height: getProportionateScreenHeight(18)),
                Text(
                  'Checklist items',
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(16),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(12)),
                if (currentPlan.items.isEmpty)
                  Text(
                    'No items in this plan yet.',
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(14),
                      color: AppColors.textSecondary,
                    ),
                  )
                else
                  ...currentPlan.items.map(
                    (item) => Padding(
                      padding: EdgeInsets.only(
                        bottom: getProportionateScreenHeight(10),
                      ),
                      child: Dismissible(
                        key: ValueKey('${currentPlan.id}-${item.id}'),
                        direction: DismissDirection.horizontal,
                        onDismissed: (_) {
                          context.read<PlanProvider>().deletePlanItem(
                                currentPlan.id,
                                item.id,
                              );
                        },
                        background: const DeleteBackground(
                          alignment: Alignment.centerLeft,
                        ),
                        secondaryBackground: const DeleteBackground(
                          alignment: Alignment.centerRight,
                        ),
                        child: ChecklistTile(
                          title: item.title,
                          isChecked: item.isChecked,
                          onToggle: () =>
                              context.read<PlanProvider>().togglePlanItem(
                                    currentPlan.id,
                                    item.id,
                                  ),
                          onTap: () => showItemDialog(
                            context,
                            planId: currentPlan.id,
                            item: item,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
