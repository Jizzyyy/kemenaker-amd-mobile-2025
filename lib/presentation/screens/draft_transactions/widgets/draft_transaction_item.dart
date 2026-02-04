import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/gradient_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../domain/entities/draft_transaction.dart';

class DraftTransactionItem extends StatelessWidget {
  final DraftTransaction draft;
  final VoidCallback onReview;
  final VoidCallback onDelete;

  const DraftTransactionItem({
    super.key,
    required this.draft,
    required this.onReview,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = draft.type == DraftTransactionType.income;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? GradientTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: isDark
            ? Border.all(
                color: GradientTheme.darkBorder,
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
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              children: [
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        draft.title,
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
                              draft.category,
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
                            DateFormatter.format(draft.date),
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
                ShaderMask(
                  shaderCallback: (bounds) => (isIncome
                          ? GradientTheme.incomeGradient
                          : GradientTheme.expenseGradient)
                      .createShader(bounds),
                  child: Text(
                    '${isIncome ? '+' : '-'} ${CurrencyFormatter.format(draft.amount)}',
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
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    draft.sourceApp,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark
                          ? GradientTheme.darkTextSecondary
                          : Colors.grey[600],
                      fontFamily: 'SFRegular',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: onDelete,
                  child: Text(
                    'Hapus',
                    style: TextStyle(
                      fontFamily: 'SFSemibold',
                      fontSize: 14.sp,
                      color: const Color(0xFFf5576c),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    backgroundColor: const Color(0xFF2196F3),
                  ),
                  onPressed: onReview,
                  child: Text(
                    'Tinjau',
                    style: TextStyle(
                      fontFamily: 'SFSemibold',
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
