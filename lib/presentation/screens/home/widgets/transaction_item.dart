import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../core/theme/gradient_theme.dart';
import '../../../../core/utils/formatters.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? GradientTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(24.r), // Match SummaryCard radius
        border: isDark
            ? Border.all(
                color: GradientTheme.darkBorder,
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            // Use same shadow as SummaryCard (reverted optimized 10 back to 20 per user request)
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Icon with gradient
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    gradient: isIncome
                        ? GradientTheme.incomeGradient
                        : GradientTheme.expenseGradient,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 16.w),

                // Transaction details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'SFMedium',
                          color: isDark
                              ? GradientTheme.darkTextPrimary
                              : GradientTheme.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              transaction.category,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isDark
                                    ? GradientTheme.darkTextSecondary
                                    : Colors.grey[600],
                                fontFamily: 'SFRegular',
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '•',
                            style: TextStyle(
                              color: isDark
                                  ? GradientTheme.darkTextSecondary
                                  : Colors.grey[600],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            DateFormatter.format(transaction.date),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDark
                                  ? GradientTheme.darkTextSecondary
                                  : Colors.grey[600],
                              fontFamily: 'SFRegular',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                // Amount
                ShaderMask(
                  shaderCallback: (bounds) => (isIncome
                          ? GradientTheme.incomeGradient
                          : GradientTheme.expenseGradient)
                      .createShader(bounds),
                  child: Text(
                    '${isIncome ? '+' : '-'} ${CurrencyFormatter.format(transaction.amount)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'SFBold',
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
