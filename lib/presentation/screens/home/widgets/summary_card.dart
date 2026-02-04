import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/gradient_theme.dart';
import '../../../../core/utils/formatters.dart';

class SummaryCard extends StatelessWidget {
  final double balance;
  final double totalIncome;
  final double totalExpense;

  const SummaryCard({
    super.key,
    required this.balance,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        // Dark mode: Dark surface with border (like unselected filter chip)
        color: isDark
            ? GradientTheme.darkSurface // Dark Surface (#1E293B)
            : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: isDark
            ? Border.all(
                color: GradientTheme.darkBorder, // Dark border
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            // Total Saldo Section
            Text(
              'Total Saldo',
              style: TextStyle(
                fontFamily: 'SFRegular',
                color: isDark
                    ? GradientTheme.darkTextSecondary
                    : GradientTheme.lightTextSecondary,
                fontSize: 16.sp,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              CurrencyFormatter.format(balance),
              style: TextStyle(
                color: isDark
                    ? GradientTheme.darkTextPrimary
                    : GradientTheme.lightTextPrimary,
                fontSize: 32.sp,
                fontFamily: 'SFBold',
                letterSpacing: 0.5,
              ),
            ),

            // Divider
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    isDark
                        ? GradientTheme.darkBorder.withOpacity(0.5)
                        : Colors.grey.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Income & Expense Row
            Row(
              children: [
                // Income
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.arrow_downward,
                    label: 'Pemasukan',
                    amount: totalIncome,
                    iconColor: isDark
                        ? GradientTheme.darkPrimary // #2DD4BF Teal Pastel
                        : GradientTheme.lightPrimary, // #009688 Teal
                    isDark: isDark,
                  ),
                ),

                // Vertical Divider
                Container(
                  width: 1,
                  height: 50.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        isDark
                            ? GradientTheme.darkBorder.withOpacity(0.5)
                            : Colors.grey.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // Expense
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.arrow_upward,
                    label: 'Pengeluaran',
                    amount: totalExpense,
                    iconColor: isDark
                        ? GradientTheme.darkAccent // #FB7185 Soft Rose
                        : GradientTheme.lightAccent, // #FF7043 Coral
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required double amount,
    required Color iconColor,
    required bool isDark,
  }) {
    return Column(
      children: [
        // Icon Circle - Colored for information
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: iconColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20.sp,
          ),
        ),

        SizedBox(height: 12.h),

        // Label
        Text(
          label,
          style: TextStyle(
            color: isDark
                ? GradientTheme.darkTextSecondary
                : GradientTheme.lightTextSecondary,
            fontSize: 12.sp,
            fontFamily: 'SFRegular',
          ),
        ),

        SizedBox(height: 4.h),

        // Amount - Colored for information
        Text(
          CurrencyFormatter.format(amount),
          style: TextStyle(
            color: iconColor,
            fontSize: 18.sp,
            fontFamily: 'SFBold',
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
