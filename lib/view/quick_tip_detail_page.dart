import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/size_config.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/utils.dart';
import '../core/widgets/gradient_logo_app_bar.dart';
import '../core/widgets/quick_tip_listtile.dart';
import '../view_model/checklist_provider.dart';



class QuickTipDetailPage extends StatelessWidget {
  const QuickTipDetailPage({
    required this.title,
    required this.imagePath,
    required this.description,
    required this.items,
    this.mode = QuickTipDetailMode.standard,
    this.itemDetails = const {},
    super.key,
  });

  final String title;
  final String imagePath;
  final String description;
  final List<String> items;
  final QuickTipDetailMode mode;
  final Map<String, String> itemDetails;

  Future<void> _handleChecklistItemTap(
    BuildContext context,
    String item,
  ) async {
    final bool? shouldAdd = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add to checklist?'),
          content: Text('Do you want to add "$item" to your gym checklist?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (shouldAdd != true || !context.mounted) {
      return;
    }

    final bool added =
        await context.read<ChecklistProvider>().addItemIfAbsent(item);

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          added
              ? '"$item" was added to your gym checklist.'
              : '"$item" is already in your gym checklist.',
        ),
      ),
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
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: AspectRatio(
                    aspectRatio: 1.8,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(24),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(14),
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(24)),
                ...items.asMap().entries.map(
                      (entry) => Padding(
                        padding: EdgeInsets.only(
                          bottom: getProportionateScreenHeight(12),
                        ),
                        child: QuickTipListTile(
                          index: entry.key + 1,
                          label: entry.value,
                          detail: itemDetails[entry.value],
                          mode: mode,
                          onTap: mode == QuickTipDetailMode.addToChecklist
                              ? () => _handleChecklistItemTap(
                                    context,
                                    entry.value,
                                  )
                              : null,
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






