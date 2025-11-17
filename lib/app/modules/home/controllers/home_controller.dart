import 'package:get/get.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';

class HomeController extends GetxController {
  final TransactionRepository _repository = TransactionRepository();

  // Observable variables
  final transactions = <TransactionModel>[].obs;
  final filteredTransactions = <TransactionModel>[].obs;
  final totalIncome = 0.0.obs;
  final totalExpense = 0.0.obs;
  final balance = 0.0.obs;
  final isLoading = false.obs;
  final selectedFilter = 'all'.obs; // all, income, expense

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      isLoading.value = true;
      transactions.value = await _repository.getAllTransactions();
      filteredTransactions.value = transactions;
      await calculateTotals();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data transaksi',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> calculateTotals() async {
    totalIncome.value = await _repository.getTotalIncome();
    totalExpense.value = await _repository.getTotalExpense();
    balance.value = await _repository.getBalance();
  }

  void filterTransactions(String filter) {
    selectedFilter.value = filter;
    if (filter == 'all') {
      filteredTransactions.value = transactions;
    } else {
      filteredTransactions.value = transactions
          .where((transaction) => transaction.type == filter)
          .toList();
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await _repository.deleteTransaction(id);
      Get.snackbar(
        'Sukses',
        'Transaksi berhasil dihapus',
        snackPosition: SnackPosition.TOP,
      );
      await loadTransactions();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus transaksi',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void goToAddTransaction() {
    Get.toNamed('/add-transaction')?.then((_) => loadTransactions());
  }

  void goToTransactionDetail(TransactionModel transaction) {
    Get.toNamed(
      '/transaction-detail',
      arguments: transaction,
    )?.then((_) => loadTransactions());
  }
}
