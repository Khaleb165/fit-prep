import 'package:flutter/material.dart';

import '../constants/size_config.dart';
import '../utils/theme/app_colors.dart';
import 'number_badge.dart';

class ExpandableQuickTipListTile extends StatelessWidget {
  const ExpandableQuickTipListTile({
    required this.index,
    required this.label,
    required this.detail,
    super.key,
  });

  final int index;
  final String label;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(14),
            vertical: getProportionateScreenHeight(4),
          ),
          childrenPadding: EdgeInsets.fromLTRB(
            getProportionateScreenWidth(54),
            0,
            getProportionateScreenWidth(14),
            getProportionateScreenHeight(16),
          ),
          leading: NumberBadge(index: index),
          iconColor: AppColors.deepBlue,
          collapsedIconColor: AppColors.textSecondary,
          title: Text(
            label,
            style: TextStyle(
              fontSize: getProportionateScreenHeight(14),
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                detail,
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(13),
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}