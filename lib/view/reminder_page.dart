import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/size_config.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/utils.dart';
import '../core/widgets/gradient_logo_app_bar.dart';
import '../core/widgets/reminder_period_selector.dart';
import '../model/workout_plan.dart';
import '../view_model/checklist_provider.dart';
import '../view_model/plan_provider.dart';
import 'home_screen.dart';
import 'plan_detail_page.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  late final PlanProvider _planProvider;
  bool _didLoadInitialState = false;
  bool _isSaving = false;
  int _selectedPeriodIndex = 0;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 7, minute: 0);
  bool _remindBefore = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoadInitialState) {
      return;
    }

    _planProvider = context.read<PlanProvider>();
    final reminderDraft = _planProvider.reminderDraft;
    _selectedPeriodIndex = reminderDraft.selectedPeriodIndex;
    _selectedTime = reminderDraft.timeOfDay;
    _remindBefore = reminderDraft.remindBefore;
    _didLoadInitialState = true;
  }

  Future<void> _persistDraft() async {
    await _planProvider.updateReminderDraft(
      _planProvider.reminderDraft.copyWith(
        selectedPeriodIndex: _selectedPeriodIndex,
        hour: _selectedTime.hour,
        minute: _selectedTime.minute,
        remindBefore: _remindBefore,
      ),
    );
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime == null) {
      return;
    }

    setState(() {
      _selectedTime = pickedTime;
    });
    await _persistDraft();
  }

  Future<void> _savePlan(BuildContext context) async {
    if (_isSaving) {
      return;
    }

    final checklistProvider = context.read<ChecklistProvider>();
    final planProvider = context.read<PlanProvider>();

    if (checklistProvider.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Add items to your checklist first before saving a reminder.'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final plan = await planProvider.createPlanFromChecklist(
        checklistProvider.items,
      );
      if (plan == null || !context.mounted) {
        return;
      }

      await checklistProvider.clearItems();
      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomePage(initialTabIndex: 1),
        ),
        (route) => false,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    final WorkoutPlan? latestPlan = context.watch<PlanProvider>().latestPlan;

    return Scaffold(
      appBar: const GradientLogoAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundLightGrey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set Gym Reminder',
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(22),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                Text(
                  'When do you usually go to the gym?',
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(15),
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                ReminderPeriodSelector(
                  periods: periods,
                  selectedIndex: _selectedPeriodIndex,
                  onSelected: (index) {
                    setState(() {
                      _selectedPeriodIndex = index;
                    });
                    _persistDraft();
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.cardWhite,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Packing time',
                              style: TextStyle(
                                fontSize: getProportionateScreenHeight(15),
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: getProportionateScreenHeight(14)),
                            OutlinedButton(
                              onPressed: _pickTime,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 18,
                                ),
                                side: const BorderSide(
                                  color: AppColors.borderDivider,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.schedule_outlined,
                                    color: AppColors.deepBlue,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      MaterialLocalizations.of(context)
                                          .formatTimeOfDay(
                                        _selectedTime,
                                        alwaysUse24HourFormat:
                                            MediaQuery.of(context)
                                                .alwaysUse24HourFormat,
                                      ),
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenHeight(24),
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Change',
                                    style: TextStyle(
                                      fontSize:
                                          getProportionateScreenHeight(14),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.deepBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(18)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.cardWhite,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Reminder: 1 hour before',
                                style: TextStyle(
                                  fontSize: getProportionateScreenHeight(15),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Switch(
                              value: _remindBefore,
                              activeColor: AppColors.cardWhite,
                              activeTrackColor: AppColors.vibrantGreen,
                              inactiveThumbColor: AppColors.cardWhite,
                              inactiveTrackColor: AppColors.borderDivider,
                              onChanged: (value) {
                                setState(() {
                                  _remindBefore = value;
                                });
                                _persistDraft();
                              },
                            ),
                          ],
                        ),
                      ),
                      if (latestPlan != null) ...[
                        SizedBox(height: getProportionateScreenHeight(18)),
                        Material(
                          color: AppColors.cardWhite,
                          borderRadius: BorderRadius.circular(24),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlanDetailPage(plan: latestPlan),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 16,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundLightGrey,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.notifications_none_rounded,
                                      color: AppColors.deepBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      'Reminder set for ${latestPlan.reminderSettings.formatTime(context)}',
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Padding(
          padding: EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppColors.ctaButtonGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ElevatedButton(
              onPressed: _isSaving ? null : () => _savePlan(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : const Text(
                      'Save Reminder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
              
            ),
          ),
        ),
      ),
    );
  }
}
