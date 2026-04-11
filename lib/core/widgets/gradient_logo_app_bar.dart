import 'package:flutter/material.dart';
import '../constants/concave_clipper.dart';
import '../theme/app_colors.dart';

class GradientLogoAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GradientLogoAppBar({
    this.actions,
    super.key,
  });

  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ConcaveAppBarClipper(),
      child: AppBar(
        toolbarHeight: 110,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Image.asset(
            'assets/images/appbar-logo.png',
            height: 38,
          ),
        ),
        actions: actions,
      ),
    );
  }
}
