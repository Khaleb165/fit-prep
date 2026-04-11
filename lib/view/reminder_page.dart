import 'package:flutter/material.dart';

import '../core/constants/size_config.dart';
import '../core/utils/theme/app_colors.dart';
import '../core/utils/utils.dart';
import '../core/widgets/gradient_logo_app_bar.dart';
import '../core/widgets/reminder_period_selector.dart';
import '../core/widgets/time_wheel.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  int _selectedPeriodIndex = 0;
  int _selectedHourIndex = 6;
  int _selectedMinuteIndex = 0;
  int _selectedMeridiemIndex = 0;
  bool _remindBefore = true;

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
            onPressed: () {},
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
