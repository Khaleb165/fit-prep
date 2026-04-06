import 'package:flutter/material.dart';

import '../../core/constants/size_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/quick_tip_card.dart';
import '../checklist_page.dart';
import '../quick_tip_detail_page.dart';
import '../reminder_page.dart';
import '../../core/widgets/action_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  static const List<String> _gymEssentials = [
    'Water bottle',
    'Gym towel',
    'Training shoes',
    'Comfortable workout clothes',
    'Headphones or earbuds',
    'Lock for your gym locker',
  ];

  static const List<String> _healthySnacks = [
    'Greek yogurt with berries',
    'Banana with peanut butter',
    'Trail mix with nuts and seeds',
    'Apple slices with almond butter',
    'Protein bar with low added sugar',
    'Boiled eggs and whole-grain crackers',
  ];

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        child: Column(
          crossAxisAlignment: crossStart,
          children: [
            Text(
              "Let's get ready for your next workout",
              style: TextStyle(
                fontSize: getProportionateScreenHeight(14),
                fontWeight: FontWeight.w600,
                height: 1.2,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(24)),
            Row(
              crossAxisAlignment: crossStart,
              children: [
                Expanded(
                  child: ActionCard(
                    title: 'Pack your bag',
                    imagePath: 'assets/images/pack-bag.png',
                    subtitle: 'Create your checklist',
                    buttonLabel: 'Get started',
                    buttonColor: AppColors.vibrantGreen,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChecklistPage(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: getProportionateScreenHeight(10)),
                Expanded(
                  child: ActionCard(
                    title: 'Set a reminder',
                    imagePath: 'assets/images/reminder.png',
                    subtitle: 'Plan your workout time',
                    buttonLabel: 'Set reminder',
                    buttonColor: AppColors.deepBlue,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ReminderPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(28)),
            Text(
              'Quick Tips',
              style: TextStyle(
                fontSize: getProportionateScreenHeight(18),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(8)),
            Text(
              'Tap a card to explore practical tips for your workout routine.',
              style: TextStyle(
                fontSize: getProportionateScreenHeight(12),
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(16)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: QuickTipCard(
                    imagePath: 'assets/images/dumbbell.png',
                    title: 'Gym essentials',
                    subtitle: 'Must-have items for your workout',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const QuickTipDetailPage(
                            title: 'Gym essentials',
                            imagePath: 'assets/images/dumbbell.png',
                            description:
                                'Keep these basics ready so each gym session starts smoothly.',
                            items: _gymEssentials,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(12)),
                Expanded(
                  child: QuickTipCard(
                    imagePath: 'assets/images/snack_bowl.png',
                    title: 'Healthy snacks',
                    subtitle: 'Best snacks to fuel your fitness',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const QuickTipDetailPage(
                            title: 'Healthy snacks',
                            imagePath: 'assets/images/snack_bowl.png',
                            description:
                                'Simple snack ideas to support energy before or after training.',
                            items: _healthySnacks,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
