import 'package:fit_prep/data/offline/hive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/size_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/utils.dart' as utils;
import '../../core/widgets/quick_tip_card.dart';
import '../../model/preset_data.dart';
import '../../view_model/preset_provider.dart';
import '../checklist_page.dart';
import '../quick_tip_detail_page.dart';
import '../reminder_page.dart';
import '../../core/widgets/action_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Future<void> _openGymEssentials(BuildContext context) async {
    final presets = await _fetchPresetsForCard(context);
    if (presets == null || !context.mounted) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuickTipDetailPage(
          title: 'Gym essentials',
          imagePath: 'assets/images/dumbbell.png',
          description:
              'Keep these basics ready so each gym session starts smoothly.',
          items: presets.gymEssentialTitles,
          mode: utils.QuickTipDetailMode.addToChecklist,
        ),
      ),
    );
  }

  Future<void> _openHealthySnacks(BuildContext context) async {
    final presets = await _fetchPresetsForCard(context);
    if (presets == null || !context.mounted) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuickTipDetailPage(
          title: 'Healthy snacks',
          imagePath: 'assets/images/snack_bowl.png',
          description:
              'Simple snack ideas to support energy before or after training.',
          items: presets.healthySnackTitles,
          mode: utils.QuickTipDetailMode.expandableInfo,
          itemDetails: presets.healthySnackDescriptionsByTitle,
        ),
      ),
    );
  }

  Future<FitnessPresetData?> _fetchPresetsForCard(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final rootNavigator = Navigator.of(context, rootNavigator: true);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final presets = await context.read<PresetProvider>().refreshFromBackend(
            rethrowErrors: true,
          );

      if (context.mounted) {
        rootNavigator.pop();
      }

      return presets;
    } catch (error) {
      debugPrint('Failed to fetch preset card data: $error');
      if (context.mounted) {
        rootNavigator.pop();
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Could not load tips from the backend.'),
          ),
        );
      }

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    final username = HiveStorage.instance.getUsername() ?? 'User';
    final presetProvider = context.watch<PresetProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $username!',
              style: TextStyle(
                fontSize: getProportionateScreenHeight(20),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    onTap: presetProvider.isLoading
                        ? null
                        : () => _openGymEssentials(context),
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(12)),
                Expanded(
                  child: QuickTipCard(
                    imagePath: 'assets/images/snack_bowl.png',
                    title: 'Healthy snacks',
                    subtitle: 'Best snacks to fuel your fitness',
                    onTap: presetProvider.isLoading
                        ? null
                        : () => _openHealthySnacks(context),
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
