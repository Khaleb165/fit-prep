import 'package:fit_prep/core/constants/size_config.dart';
import 'package:fit_prep/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(30),
                  fontWeight: FontWeight.bold,
                  color: AppColors.cardWhite,
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(8)),
              Image.asset(
                'assets/images/appbar-logo.png',
                width: getProportionateScreenWidth(120),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          Text(
            'Checklist and reminders made simple.',
            style: TextStyle(
              fontSize: getProportionateScreenWidth(12),
              color: AppColors.cardWhite,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(32)),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppColors.ctaButtonGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: AppColors.cardWhite,
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(40),
                  vertical: getProportionateScreenHeight(14),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(16),
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
