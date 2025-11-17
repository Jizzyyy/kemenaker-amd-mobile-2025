import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';

class TransactionDetailController extends GetxController {
  final TransactionRepository _repository = TransactionRepository();

  late TransactionModel transaction;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    transaction = Get.arguments as TransactionModel;
  }

  Future<void> deleteTransaction() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin menghapus transaksi ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        isLoading.value = true;
        await _repository.deleteTransaction(transaction.id!);
        Get.back(result: true);
        Get.snackbar(
          'Sukses',
          'Transaksi berhasil dihapus',
          snackPosition: SnackPosition.TOP,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal menghapus transaksi',
          snackPosition: SnackPosition.TOP,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  void editTransaction() {
    Get.toNamed('/edit-transaction', arguments: transaction)?.then((result) {
      if (result == true) {
        Get.back(result: true);
      }
    });
  }
}
