import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon/Logo
            Image.asset(
              'assets/images/app_icon.png',
              width: 190,
              height: 190,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback jika image tidak ditemukan
                return const Icon(
                  Icons.account_balance_wallet,
                  size: 120,
                  color: Colors.blue,
                );
              },
            ),
            const SizedBox(height: 24),
            
            // App Name
            Text(
                'Aplikasi Pencatatan Keuangan',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'SFBold',
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
          
            

          ],
        ),
      ),
    );
  }
}
