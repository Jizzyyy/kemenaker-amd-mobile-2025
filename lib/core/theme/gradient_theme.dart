import 'package:flutter/material.dart';

class GradientTheme {
  // ==================== LIGHT MODE (Teal & Coral) ====================

  // Light Primary Gradient (Teal)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF009688), Color(0xFF00796B)], // Teal gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light Expense Gradient (Deep Coral)
  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFFF7043), Color(0xFFFF5722)], // Deep Coral
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light Income Gradient (Teal - for income)
  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFF26A69A), Color(0xFF009688)], // Lighter Teal
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light Card Gradient (Soft Teal)
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF80CBC4), Color(0xFF4DB6AC)], // Soft Teal
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light Subtle Gradient
  static const LinearGradient subtleGradient = LinearGradient(
    colors: [Color(0xFFB2DFDB), Color(0xFFFFCCBC)], // Teal to Coral soft
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== DARK MODE (Slate & Neon Pastel) ====================

  // Dark Primary Gradient (Teal Pastel/Neon - untuk income/saldo)
  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [Color(0xFF2DD4BF), Color(0xFF14B8A6)], // Teal Pastel/Neon
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark Expense Gradient (Soft Rose/Coral - untuk pengeluaran)
  static const LinearGradient expenseGradientDark = LinearGradient(
    colors: [Color(0xFFFB7185), Color(0xFFF43F5E)], // Soft Rose/Coral
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark Income Gradient (Teal Neon - untuk income)
  static const LinearGradient incomeGradientDark = LinearGradient(
    colors: [Color(0xFF2DD4BF), Color(0xFF14B8A6)], // Teal Pastel/Neon
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark Background Gradient
  static const LinearGradient backgroundGradientDark = LinearGradient(
    colors: [
      Color(0xFF0F172A), // Background utama
      Color(0xFF0F172A),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Dark Card Gradient (Surface)
  static const LinearGradient cardGradientDark = LinearGradient(
    colors: [
      Color(0xFF1E293B), // Surface
      Color(0xFF1E293B),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark Surface Gradient
  static const LinearGradient surfaceGradientDark = LinearGradient(
    colors: [
      Color(0xFF1E293B), // Surface
      Color(0xFF1E293B),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== COLORS ====================

  // Light Mode Colors
  static const Color lightBackground =
      Color(0xFFF4F7F6); // Abu-abu kehijauan muda
  static const Color lightSurface = Color(0xFFFFFFFF); // Putih bersih
  static const Color lightTextPrimary = Color(0xFF1E293B); // Slate Grey
  static const Color lightTextSecondary = Color(0xFF64748b); // Medium grey
  static const Color lightPrimary = Color(0xFF009688); // Teal
  static const Color lightAccent = Color(0xFFFF7043); // Deep Coral

  // Dark Mode Colors - Slate & Neon Pastel
  static const Color darkBackground =
      Color(0xFF0F172A); // Background utama (dark blue)
  static const Color darkSurface =
      Color(0xFF1E293B); // Surface (Card/Input/Header)
  static const Color darkSurfaceVariant = Color(0xFF1E293B); // Same as surface
  static const Color darkTextPrimary = Color(0xFFF1F5F9); // Putih Gading
  static const Color darkTextSecondary =
      Color(0xFF94A3B8); // Abu-abu biru (hint/secondary)
  static const Color darkTextTertiary = Color(0xFF64748b); // Muted text
  static const Color darkPrimary =
      Color(0xFF2DD4BF); // Teal Pastel/Neon (income/saldo)
  static const Color darkAccent =
      Color(0xFFFB7185); // Soft Rose/Coral (expense)
  static const Color darkBorder = Color(0xFF334155); // Border color

  // ==================== HELPER METHODS ====================

  static LinearGradient getPrimaryGradient(bool isDark) {
    return isDark ? primaryGradientDark : primaryGradient;
  }

  static LinearGradient getExpenseGradient(bool isDark) {
    return isDark ? expenseGradientDark : expenseGradient;
  }

  static LinearGradient getIncomeGradient(bool isDark) {
    return isDark ? incomeGradientDark : incomeGradient;
  }

  static LinearGradient getCardGradient(bool isDark) {
    return isDark ? cardGradientDark : cardGradient;
  }

  static LinearGradient getBackgroundGradient(bool isDark) {
    return isDark
        ? backgroundGradientDark
        : const LinearGradient(
            colors: [Color(0xFFF4F7F6), Color(0xFFF4F7F6)],
          );
  }

  static LinearGradient getSurfaceGradient(bool isDark) {
    return isDark
        ? surfaceGradientDark
        : const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
          );
  }

  static Color getBackgroundColor(bool isDark) {
    return isDark ? darkBackground : lightBackground;
  }

  static Color getSurfaceColor(bool isDark) {
    return isDark ? darkSurface : lightSurface;
  }

  static Color getSurfaceVariantColor(bool isDark) {
    return isDark ? darkSurfaceVariant : lightSurface;
  }

  static Color getTextPrimaryColor(bool isDark) {
    return isDark ? darkTextPrimary : lightTextPrimary;
  }

  static Color getTextSecondaryColor(bool isDark) {
    return isDark ? darkTextSecondary : lightTextSecondary;
  }

  static Color getBorderColor(bool isDark) {
    return isDark ? darkBorder : const Color(0xFFE2E8F0);
  }

  static Color getPrimaryColor(bool isDark) {
    return isDark ? darkPrimary : lightPrimary;
  }

  static Color getAccentColor(bool isDark) {
    return isDark ? darkAccent : lightAccent;
  }
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient ?? GradientTheme.getPrimaryGradient(isDark),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: (gradient?.colors.first ??
                    GradientTheme.getPrimaryColor(isDark))
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

// Gradient AppBar Widget
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool isDark;

  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isActuallyDark = brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        // Use surface color in dark mode, gradient in light mode
        gradient:
            isActuallyDark ? null : GradientTheme.getPrimaryGradient(false),
        color: isActuallyDark
            ? GradientTheme.darkSurface
            : null, // Surface (#1E293B)
      ),
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'SFBold',
            color:
                isActuallyDark ? GradientTheme.darkTextPrimary : Colors.white,
          ),
        ),
        leading: leading,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: actions,
        iconTheme: IconThemeData(
          color: isActuallyDark ? GradientTheme.darkTextPrimary : Colors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
