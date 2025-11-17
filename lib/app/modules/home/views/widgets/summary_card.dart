import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'summary_item.dart';

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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Total Saldo',
            style: TextStyle(
              fontFamily: 'SFBold',
              color: Colors.white70,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _CurrencyFormatter.format(balance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontFamily: 'SFBold',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SummaryItem(
                  label: 'Pemasukan',
                  amount: totalIncome,
                  icon: Icons.arrow_downward,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SummaryItem(
                  label: 'Pengeluaran',
                  amount: totalExpense,
                  icon: Icons.arrow_upward,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
