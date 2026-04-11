import 'package:flutter/material.dart';

import '../constants/size_config.dart';
import '../utils/theme/app_colors.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    required this.title,
    required this.imagePath,
    required this.subtitle,
    required this.buttonLabel,
    required this.buttonColor,
    this.onPressed,
    super.key,
  });

  final String title;
  final String imagePath;
  final String subtitle;
  final String buttonLabel;
  final Color buttonColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenHeight(10),
          vertical: getProportionateScreenHeight(20)),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: getProportionateScreenHeight(14),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          // const SizedBox(height: 18),
          AspectRatio(
            aspectRatio: 2,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          // const SizedBox(height: 18),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: getProportionateScreenHeight(12),
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
