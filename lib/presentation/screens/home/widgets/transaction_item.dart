import 'package:flutter/material.dart';
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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon with gradient
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

              // Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
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
                          transaction.category,
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
                          DateFormatter.format(transaction.date),
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

              // Amount
              ShaderMask(
                shaderCallback: (bounds) => (isIncome
                        ? GradientTheme.incomeGradient
                        : GradientTheme.expenseGradient)
                    .createShader(bounds),
                child: Text(
                  '${isIncome ? '+' : '-'} ${CurrencyFormatter.format(transaction.amount)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'SFBold',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
