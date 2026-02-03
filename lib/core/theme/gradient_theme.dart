import 'package:flutter/material.dart';

class GradientTheme {
  // Primary gradient for AppBars and main buttons - Soft Blue to Purple
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Card gradient for summary cards - Soft Blue gradient
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF667eea), Color(0xFF5b9fd8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Income gradient - Soft Green
  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFF56ab2f), Color(0xFF7dd56f)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Expense gradient - Soft Red/Orange
  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Background gradient for splash/onboarding
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Subtle gradient for cards
  static const LinearGradient subtleGradient = LinearGradient(
    colors: [Color(0xFFBBDEFB), Color(0xFFE1BEE7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark gradient for contrast
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1565C0), Color(0xFF6A1B9A)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

// Gradient Button Widget
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final LinearGradient? gradient;
  final double? width;
  final double? height;
  final double borderRadius;
  final TextStyle? textStyle;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.width,
    this.height,
    this.borderRadius = 10,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient ?? GradientTheme.primaryGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: (gradient?.colors.first ?? const Color(0xFF2196F3))
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: textStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}

// Gradient AppBar
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final LinearGradient? gradient;

  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'SFSemibold',
          color: Colors.white,
          fontSize: 24,
        ),
      ),
      leading: leading,
      actions: actions,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: gradient ?? GradientTheme.primaryGradient,
        ),
      ),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
