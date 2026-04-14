import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/size_config.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/utils.dart';
import '../core/widgets/checklist_tile.dart';
import '../core/widgets/delete_background.dart';
import '../core/widgets/gradient_logo_app_bar.dart';
import '../core/widgets/reminder_card.dart';
import '../model/checklist_item.dart';
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
    TimeOfDay selectedTime = plan.reminderSettings.timeOfDay;
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
                    Text(
                      'Packing time',
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    OutlinedButton(
                      onPressed: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );

                        if (pickedTime == null) {
                          return;
                        }

                        setState(() {
                          selectedTime = pickedTime;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(
                        MaterialLocalizations.of(context).formatTimeOfDay(
                          selectedTime,
                          alwaysUse24HourFormat:
                              MediaQuery.of(context).alwaysUse24HourFormat,
                        ),
                        style: TextStyle(
                          fontSize: getProportionateScreenHeight(16),
                          color: AppColors.textPrimary,
                        ),
                      ),
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
                        hour: selectedTime.hour,
                        minute: selectedTime.minute,
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
                else ...[
                  ...currentPlan.items.where((item) => !item.isChecked).map(
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
                  if (currentPlan.items.any((item) => item.isChecked))
                    _CompletedItemsSection(
                      plan: currentPlan,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompletedItemsSection extends StatelessWidget {
  const _CompletedItemsSection({
    required this.plan,
  });

  final WorkoutPlan plan;

  @override
  Widget build(BuildContext context) {
    final List<ChecklistItem> completedItems =
        plan.items.where((item) => item.isChecked).toList(growable: false);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        margin: EdgeInsets.only(top: getProportionateScreenHeight(4)),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(24),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
          title: Text(
            'Completed items (${completedItems.length})',
            style: TextStyle(
              fontSize: getProportionateScreenHeight(15),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            'Hidden until you expand them.',
            style: TextStyle(
              fontSize: getProportionateScreenHeight(13),
              color: AppColors.textSecondary,
            ),
          ),
          children: completedItems
              .map<Widget>(
                (item) => Padding(
                  padding: EdgeInsets.only(
                    bottom: getProportionateScreenHeight(10),
                  ),
                  child: Dismissible(
                    key: ValueKey('${plan.id}-${item.id}-completed'),
                    direction: DismissDirection.horizontal,
                    onDismissed: (_) {
                      context.read<PlanProvider>().deletePlanItem(
                            plan.id,
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
                                plan.id,
                                item.id,
                              ),
                      onTap: () => showItemDialog(
                        context,
                        planId: plan.id,
                        item: item,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
