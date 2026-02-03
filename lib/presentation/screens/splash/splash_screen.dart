import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/gradient_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    if (!mounted) return;

    if (hasSeenOnboarding) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon/Logo with smooth animations
              Image.asset(
                'assets/images/app_icon.png',
                width: 190.w,
                height: 190.w,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 190.w,
                    height: 190.w,
                    decoration: BoxDecoration(
                      gradient: GradientTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_wallet,
                      size: 100.sp,
                      color: Colors.white,
                    ),
                  );
                },
              )
                  .animate()
                  .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                  )
                  .then(delay: 200.ms)
                  .shimmer(
                    duration: 1200.ms,
                    color: Colors.white.withOpacity(0.3),
                  ),
              SizedBox(height: 24.h),

              // App Name with gradient and fade/slide animation
              ShaderMask(
                shaderCallback: (bounds) =>
                    GradientTheme.primaryGradient.createShader(bounds),
                child: Text(
                  'Aplikasi Pencatatan Keuangan',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: 'SFSemibold',
                    color: Colors.white,
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 600.ms,
                    curve: Curves.easeOut,
                  ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
