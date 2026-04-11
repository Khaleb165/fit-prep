import 'package:flutter/material.dart';

import '../constants/size_config.dart';
import '../utils/theme/app_colors.dart';

class QuickTipCard extends StatelessWidget {
  const QuickTipCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.onTap,
    super.key,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardWhite,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: AspectRatio(
                  aspectRatio: 2.0,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(12)),
              Text(
                title,
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(14),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(6)),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(12),
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
