import 'package:flutter/material.dart';

import '../core/constants/size_config.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/gradient_logo_app_bar.dart';

class QuickTipDetailPage extends StatelessWidget {
  const QuickTipDetailPage({
    required this.title,
    required this.imagePath,
    required this.description,
    required this.items,
    super.key,
  });

  final String title;
  final String imagePath;
  final String description;
  final List<String> items;

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
                        child: _QuickTipListTile(
                          index: entry.key + 1,
                          label: entry.value,
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

class _QuickTipListTile extends StatelessWidget {
  const _QuickTipListTile({
    required this.index,
    required this.label,
  });

  final int index;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(14),
        vertical: getProportionateScreenHeight(14),
      ),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: getProportionateScreenWidth(28),
            height: getProportionateScreenWidth(28),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.deepBlue,
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: getProportionateScreenHeight(12),
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: getProportionateScreenWidth(12)),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: getProportionateScreenHeight(14),
                color: AppColors.textPrimary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
