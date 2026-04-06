import 'package:flutter/material.dart';

import '../../core/constants/size_config.dart';
import '../../core/theme/app_colors.dart';
import '../checklist_page.dart';
import '../reminder_page.dart';
import '../../core/widgets/action_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

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
          ],
        ),
      ),
    );
  }
}
