import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/remote_auth_service.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/gradient_logo_app_bar.dart';
import '../view_model/plan_provider.dart';
import 'homescreen_tabs/home_tab.dart';
import 'homescreen_tabs/plans_tab.dart';
import 'sign_in_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    this.initialTabIndex = 0,
    super.key,
  });

  final int initialTabIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;
  final _authService = RemoteAuthService();

  void _openSignIn() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeTab(),
      const PlansTab(),
    ];

    return Scaffold(
      extendBody: true,
      appBar: GradientLogoAppBar(
        actions: [
          // logout button
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              await _authService.signOut();
              if (!context.mounted) {
                return;
              }
              await context.read<PlanProvider>().clearLocalPlans();
              if (!context.mounted) {
                return;
              }
              _openSignIn();
            },
          ),
        ],
      ),
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
          indicatorColor: AppColors.deepBlue.withAlpha(30),
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
