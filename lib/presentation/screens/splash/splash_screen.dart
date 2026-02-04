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
    // Splash screen duration - adjust this value to change how long splash shows
    await Future.delayed(const Duration(milliseconds: 3500)); // 3.5 seconds

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? GradientTheme.darkBackground : Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // App Icon/Logo with smooth animations
              Image.asset(
                'assets/images/app_icon.png',
                width: 385.w,
                height: 385.w,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 385.w,
                    height: 385.w,
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? GradientTheme.primaryGradientDark
                          : GradientTheme.primaryGradient,
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
                    color: (isDark ? GradientTheme.darkPrimary : Colors.white)
                        .withOpacity(0.3),
                  ),
              SizedBox(height: 24.h),

              const Spacer(),

              // Developer Credit
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => (isDark
                              ? GradientTheme.primaryGradientDark
                              : GradientTheme.primaryGradient)
                          .createShader(bounds),
                      child: Text(
                        'Developed by',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'SFRegular',
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ShaderMask(
                      shaderCallback: (bounds) => (isDark
                              ? GradientTheme.primaryGradientDark
                              : GradientTheme.primaryGradient)
                          .createShader(bounds),
                      child: Text(
                        'arctic moon',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'SFSemibold',
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 800.ms, duration: 600.ms).slideY(
                    begin: 0.5,
                    end: 0,
                    duration: 600.ms,
                    curve: Curves.easeOut,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
