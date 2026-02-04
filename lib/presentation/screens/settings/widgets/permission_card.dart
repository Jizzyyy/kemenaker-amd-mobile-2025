import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/gradient_theme.dart';

class PermissionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Gradient iconGradient;
  final Color themeColor;

  const PermissionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    required this.iconGradient,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: themeColor.withOpacity(isDark ? 0.05 : 0.08),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: themeColor.withOpacity(isDark ? 0.3 : 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon with gradient background
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                gradient: iconGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: iconGradient.colors.first.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),

            // Title and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: 'SFSemibold',
                      color: isDark
                          ? GradientTheme.darkTextPrimary
                          : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isDark
                          ? GradientTheme.darkTextSecondary
                          : Colors.grey[600],
                      fontFamily: 'SFRegular',
                    ),
                  ),
                ],
              ),
            ),

            // Chevron icon
            Icon(
              Icons.chevron_right,
              color: isDark ? GradientTheme.darkTextSecondary : Colors.grey,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
