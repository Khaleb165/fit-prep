import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../features/checklist/view/homescreen_tabs/home_tab.dart';
import '../features/checklist/view/homescreen_tabs/plans_tab.dart';
import 'widgets/gradient_logo_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeTab(),
      const PlansTab(),
    ];

    return Scaffold(
      extendBody: true,
      appBar: const GradientLogoAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundLightGrey,
        child: SafeArea(
          top: false,
          child: IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.deepBlue);
            }

            return const IconThemeData(color: AppColors.textSecondary);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: AppColors.deepBlue,
                fontWeight: FontWeight.w600,
              );
            }

            return const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          height: 76,
          backgroundColor: AppColors.cardWhite,
          indicatorColor: AppColors.deepBlue.withOpacity(0.12),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: 'Plans',
            ),
          ],
        ),
      ),
    );
  }
}
