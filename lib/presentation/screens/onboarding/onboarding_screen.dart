import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/gradient_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.account_balance_wallet,
      title: 'Kelola Keuangan',
      description:
          'Catat semua pemasukan dan pengeluaran Anda dengan mudah dan terorganisir',
      color: const Color(0xFF2196F3),
    ),
    OnboardingPage(
      icon: Icons.analytics,
      title: 'Pantau Saldo',
      description:
          'Lihat ringkasan keuangan Anda secara real-time dan ketahui kondisi finansial Anda',
      color: const Color(0xFF9C27B0),
    ),
    OnboardingPage(
      icon: Icons.category,
      title: 'Kategorisasi',
      description:
          'Organisir transaksi dengan kategori untuk analisis yang lebih baik',
      color: const Color(0xFF4CAF50),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (!mounted) return;
    context.go('/home');
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        GradientTheme.primaryGradient.createShader(bounds),
                    child: Text(
                      'Lewati',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPage(page);
                },
              ),
            ),

            // Page Indicator
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: WormEffect(
                  dotHeight: 10.h,
                  dotWidth: 10.w,
                  activeDotColor: const Color(0xFF2196F3),
                  dotColor: Colors.grey.shade300,
                ),
              ),
            ),

            // Next/Start Button
            Padding(
              padding: EdgeInsets.all(20.w),
              child: GradientButton(
                text:
                    _currentPage == _pages.length - 1 ? 'Mulai' : 'Selanjutnya',
                onPressed: _nextPage,
                width: double.infinity,
                height: 54.h,
                borderRadius: 16.r,
                textStyle: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),
            // Icon with gradient
            Container(
              width: 180.w,
              height: 180.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    page.color.withOpacity(0.2),
                    page.color.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                page.icon,
                size: 90.sp,
                color: page.color,
              ),
            ),
            SizedBox(height: 40.h),

            // Title
            Text(
              page.title,
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFBold',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),

            // Description
            Text(
              page.description,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey[600],
                height: 1.5,
                fontFamily: 'SFRegular',
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
