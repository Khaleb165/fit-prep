import 'package:fit_prep/core/constants/size_config.dart';
import 'package:fit_prep/data/offline/hive.dart';
import 'package:fit_prep/view/home_screen.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Future<void> _handleGetStarted(BuildContext context) async {
    await HiveStorage.instance.setIsFirstTime(false);

    if (!context.mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.secondaryGradient,
        ),
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: getProportionateScreenHeight(30)),
              Image.asset(
                'assets/images/appbar-logo.png',
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              const Text(
                'Welcome to FitPrep!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.cardWhite,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(12)),
              const Text(
                'Get Ready for the Gym, The Easy Way!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.backgroundLightGrey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Image.asset(
                  'assets/images/welcome-logo.png',
                  fit: BoxFit.cover,
                  height: getProportionateScreenHeight(350),
                  scale: 0.5,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => _handleGetStarted(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.vibrantGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}
