import 'package:flutter/material.dart';

import '../constants/size_config.dart';
import '../utils/theme/app_colors.dart';

class NumberBadge extends StatelessWidget {
  const NumberBadge({
    required this.index,
    super.key,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
