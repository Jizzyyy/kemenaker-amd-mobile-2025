import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOnboarding();
    });
  }

  Future<void> _checkOnboarding() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      final prefs = await SharedPreferences.getInstance();
      final isOnboardingComplete = prefs.getBool('onboarding_complete') ?? false;

      print('DEBUG: Onboarding complete = $isOnboardingComplete');

      if (isOnboardingComplete) {
        print('DEBUG: Navigating to /home');
        Get.offAllNamed('/home');
      } else {
        print('DEBUG: Navigating to /onboarding');
        Get.offAllNamed('/onboarding');
      }
    } catch (e) {
      print('ERROR in splash: $e');
      // Fallback ke onboarding jika ada error
      Get.offAllNamed('/onboarding');
    }
  }
}
