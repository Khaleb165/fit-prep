import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/size_config.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/utils.dart';
import '../core/widgets/gradient_logo_app_bar.dart';
import '../core/widgets/reminder_period_selector.dart';
import '../core/widgets/time_wheel.dart';
import '../view_model/checklist_provider.dart';
import '../view_model/plan_provider.dart';
import 'home_screen.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  late final PlanProvider _planProvider;
  bool _didLoadInitialState = false;
  int _selectedPeriodIndex = 0;
  int _selectedHourIndex = 6;
  int _selectedMinuteIndex = 0;
  int _selectedMeridiemIndex = 0;
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
    _selectedHourIndex = reminderDraft.selectedHourIndex;
    _selectedMinuteIndex = reminderDraft.selectedMinuteIndex;
    _selectedMeridiemIndex = reminderDraft.selectedMeridiemIndex;
    _remindBefore = reminderDraft.remindBefore;
    _didLoadInitialState = true;
  }

  Future<void> _persistDraft() async {
    await _planProvider.updateReminderDraft(
      _planProvider.reminderDraft.copyWith(
        selectedPeriodIndex: _selectedPeriodIndex,
        selectedHourIndex: _selectedHourIndex,
        selectedMinuteIndex: _selectedMinuteIndex,
        selectedMeridiemIndex: _selectedMeridiemIndex,
        remindBefore: _remindBefore,
      ),
    );
  }

  Future<void> _savePlan(BuildContext context) async {
    final checklistProvider = context.read<ChecklistProvider>();
    final planProvider = context.read<PlanProvider>();

    if (checklistProvider.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add checklist items before creating a plan.'),
        ),
      );
      return;
    }

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
  }

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
                            SizedBox(height: getProportionateScreenHeight(15)),
                            SizedBox(
                              height: 220,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TimeWheel(
                                      items: List<String>.generate(
                                        12,
                                        (index) => '${index + 1}',
                                      ),
                                      initialIndex: _selectedHourIndex,
                                      onSelectedItemChanged: (index) {
                                        setState(() {
                                          _selectedHourIndex = index;
                                        });
                                        _persistDraft();
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenHeight(28),
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TimeWheel(
                                      items: minutes,
                                      initialIndex: _selectedMinuteIndex,
                                      onSelectedItemChanged: (index) {
                                        setState(() {
                                          _selectedMinuteIndex = index;
                                        });
                                        _persistDraft();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: TimeWheel(
                                      items: const ['AM', 'PM'],
                                      initialIndex: _selectedMeridiemIndex,
                                      onSelectedItemChanged: (index) {
                                        setState(() {
                                          _selectedMeridiemIndex = index;
                                        });
                                        _persistDraft();
                                      },
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
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.ctaButtonGradient,
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            onPressed: () => _savePlan(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Save Reminder',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
