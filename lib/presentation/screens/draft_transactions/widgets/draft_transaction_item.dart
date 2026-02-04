import 'package:flutter/material.dart';
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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: isIncome
                        ? GradientTheme.incomeGradient
                        : GradientTheme.expenseGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        draft.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'SFSemibold',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            draft.category,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontFamily: 'SFRegular',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormatter.format(draft.date),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontFamily: 'SFRegular',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => (isIncome
                          ? GradientTheme.incomeGradient
                          : GradientTheme.expenseGradient)
                      .createShader(bounds),
                  child: Text(
                    '${isIncome ? '+' : '-'} ${CurrencyFormatter.format(draft.amount)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'SFBold',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    draft.sourceApp,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'SFRegular',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: onDelete,
                  child: const Text(
                    'Hapus',
                    style: TextStyle(
                      fontFamily: 'SFSemibold',
                      color: Color(0xFFf5576c),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color(0xFF2196F3),
                  ),
                  onPressed: onReview,
                  child: const Text(
                    'Tinjau',
                    style: TextStyle(
                      fontFamily: 'SFSemibold',
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
