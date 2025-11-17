import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Kelola Keuangan',
      description: 'Catat semua transaksi pemasukan dan pengeluaran Anda dengan mudah',
      icon: Icons.account_balance_wallet,
      color: Colors.blue,
    ),
    OnboardingPage(
      title: 'Pantau Pengeluaran',
      description: 'Lihat ringkasan keuangan dan kontrol pengeluaran Anda setiap saat',
      icon: Icons.analytics,
      color: Colors.green,
    ),
    OnboardingPage(
      title: 'Lampirkan Bukti',
      description: 'Simpan foto nota atau bukti pembayaran untuk setiap transaksi',
      icon: Icons.photo_camera,
      color: Colors.orange,
    ),
  ];

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    Get.offAllNamed('/home');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
