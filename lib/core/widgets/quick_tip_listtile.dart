import 'package:flutter/material.dart';

import '../constants/size_config.dart';
import '../utils/theme/app_colors.dart';
import '../utils/utils.dart';
import 'expandable_tip_listtile.dart';
import 'number_badge.dart';

class QuickTipListTile extends StatelessWidget {
  const QuickTipListTile({
    required this.index,
    required this.label,
    required this.mode,
    this.detail,
    this.onTap,
    super.key,
  });

  final int index;
  final String label;
  final QuickTipDetailMode mode;
  final String? detail;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (mode == QuickTipDetailMode.expandableInfo) {
      return ExpandableQuickTipListTile(
        index: index,
        label: label,
        detail: detail ?? '',
      );
    }

    return Material(
      color: AppColors.cardWhite,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(14),
            vertical: getProportionateScreenHeight(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NumberBadge(index: index),
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
        ),
      ),
    );
  }
}
