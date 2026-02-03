import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../../../core/theme/gradient_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/transaction.dart';
import '../../providers/transaction_provider.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final int transactionId;

  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionNotifierProvider).transactions;
    final transaction = transactions.firstWhere(
      (t) => t.id == transactionId,
      orElse: () => throw Exception('Transaction not found'),
    );

    final isIncome = transaction.type == TransactionType.income;

    return Scaffold(
      appBar: GradientAppBar(
        title: 'Detail Transaksi',
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await context.push('/add-transaction?id=$transactionId');
              // Reload transactions after edit
              ref.read(transactionNotifierProvider.notifier).loadTransactions();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Card with Gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: isIncome
                    ? GradientTheme.incomeGradient
                    : GradientTheme.expenseGradient,
                boxShadow: [
                  BoxShadow(
                    color: (isIncome
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFF44336))
                        .withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    isIncome ? 'Pemasukan' : 'Pengeluaran',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'SFMedium',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${isIncome ? '+' : '-'} ${CurrencyFormatter.format(transaction.amount)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontFamily: 'SFBold',
                    ),
                  ),
                ],
              ),
            ),

            // Transaction Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    icon: Icons.title,
                    label: 'Judul',
                    value: transaction.title,
                  ),
                  const Divider(height: 32),
                  _buildDetailRow(
                    icon: Icons.category,
                    label: 'Kategori',
                    value: transaction.category,
                  ),
                  const Divider(height: 32),
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    label: 'Tanggal',
                    value: DateFormatter.formatLong(transaction.date),
                  ),
                  if (transaction.description != null &&
                      transaction.description!.isNotEmpty) ...[
                    const Divider(height: 32),
                    _buildDetailRow(
                      icon: Icons.description,
                      label: 'Deskripsi',
                      value: transaction.description!,
                    ),
                  ],
                  if (transaction.imagePath != null) ...[
                    const Divider(height: 32),
                    const Text(
                      'Lampiran',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SFSemibold',
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(transaction.imagePath!),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 64,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: GradientButton(
                          text: 'Edit',
                          onPressed: () async {
                            await context
                                .push('/add-transaction?id=$transactionId');
                            ref
                                .read(transactionNotifierProvider.notifier)
                                .loadTransactions();
                          },
                          gradient: GradientTheme.primaryGradient,
                          height: 50,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GradientButton(
                          text: 'Hapus',
                          onPressed: () =>
                              _showDeleteConfirmation(context, ref),
                          gradient: GradientTheme.expenseGradient,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: GradientTheme.subtleGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.grey[700]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'SFMedium',
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'SFSemibold',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Transaksi'),
        content: const Text('Apakah Anda yakin ingin menghapus transaksi ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(transactionNotifierProvider.notifier)
                  .removeTransaction(transactionId);

              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transaksi berhasil dihapus'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.go('/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gagal menghapus transaksi'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
