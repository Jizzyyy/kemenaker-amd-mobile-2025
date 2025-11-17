import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/transaction_model.dart';

class _CurrencyFormatter {
  static String format(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final color = isIncome ? Colors.green : Colors.red;
    final icon = isIncome ? Icons.arrow_downward : Icons.arrow_upward;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(
            fontFamily: 'SFBold',
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              transaction.category,
              style: const TextStyle(fontFamily: 'SFBold'),
            ),
            Text(
              DateFormat('dd MMM yyyy').format(transaction.date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontFamily: 'SFBold',
              ),
            ),
          ],
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'} ${_CurrencyFormatter.format(transaction.amount)}',
          style: TextStyle(
            color: color,
            fontFamily: 'SFBold',
            fontSize: 16,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
