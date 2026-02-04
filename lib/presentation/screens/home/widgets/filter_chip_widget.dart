import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/gradient_theme.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final String value;
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.value,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedFilter == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onFilterChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? (isDark
                  ? GradientTheme.primaryGradientDark
                  : GradientTheme.primaryGradient)
              : null,
          color: isSelected
              ? null
              : (isDark ? GradientTheme.darkSurface : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20.r),
          border: !isSelected && isDark
              ? Border.all(
                  color: GradientTheme.darkBorder,
                  width: 1,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (isDark
                            ? GradientTheme.darkPrimary
                            : const Color(0xFF2196F3))
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? GradientTheme.darkTextPrimary : Colors.grey[700]),
            fontFamily: 'SFRegular',
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
