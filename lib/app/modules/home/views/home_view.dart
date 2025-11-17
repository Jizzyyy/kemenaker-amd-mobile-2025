import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'widgets/summary_card.dart';
import 'widgets/filter_chip_widget.dart';
import 'widgets/transaction_item.dart';
import 'widgets/empty_transaction_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pencatatan Keuangan',
          style: TextStyle(
            fontFamily: 'SFSemibold',
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.loadTransactions,
          child: Column(
            children: [
              // Summary Card
              SummaryCard(
                balance: controller.balance.value,
                totalIncome: controller.totalIncome.value,
                totalExpense: controller.totalExpense.value,
              ),

              // Filter Buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    FilterChipWidget(
                      label: 'Semua',
                      value: 'all',
                      selectedFilter: controller.selectedFilter,
                      onFilterChanged: controller.filterTransactions,
                    ),
                    const SizedBox(width: 8),
                    FilterChipWidget(
                      label: 'Pemasukan',
                      value: 'income',
                      selectedFilter: controller.selectedFilter,
                      onFilterChanged: controller.filterTransactions,
                    ),
                    const SizedBox(width: 8),
                    FilterChipWidget(
                      label: 'Pengeluaran',
                      value: 'expense',
                      selectedFilter: controller.selectedFilter,
                      onFilterChanged: controller.filterTransactions,
                    ),
                  ],
                ),
              ),

              // Transaction List
              Expanded(
                child: controller.filteredTransactions.isEmpty
                    ? const EmptyTransactionWidget()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction =
                              controller.filteredTransactions[index];
                          return TransactionItem(
                            transaction: transaction,
                            onTap: () => controller.goToTransactionDetail(transaction),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToAddTransaction,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
