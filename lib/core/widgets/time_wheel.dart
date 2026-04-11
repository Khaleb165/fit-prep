import 'package:fit_prep/core/constants/size_config.dart';
import 'package:fit_prep/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TimeWheel extends StatefulWidget {
  const TimeWheel({
    required this.items,
    required this.initialIndex,
    required this.onSelectedItemChanged,
    super.key,
  });

  final List<String> items;
  final int initialIndex;
  final ValueChanged<int> onSelectedItemChanged;

  @override
  State<TimeWheel> createState() => _TimeWheelState();
}

class _TimeWheelState extends State<TimeWheel> {
  late final FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: getProportionateScreenHeight(54),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: AppColors.backgroundLightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        ListWheelScrollView.useDelegate(
          controller: _controller,
          itemExtent: getProportionateScreenHeight(54),
          diameterRatio: 1.4,
          physics: const FixedExtentScrollPhysics(),
          perspective: 0.003,
          onSelectedItemChanged: widget.onSelectedItemChanged,
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: widget.items.length,
            builder: (context, index) {
              return Center(
                child: Text(
                  widget.items[index],
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(20),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
