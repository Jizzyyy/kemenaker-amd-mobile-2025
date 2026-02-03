import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/theme/gradient_theme.dart';
import '../../../domain/entities/transaction.dart';
import '../../providers/transaction_provider.dart';
import 'widgets/summary_card.dart';
import 'widgets/filter_chip_widget.dart';
import 'widgets/transaction_item.dart';
import 'widgets/empty_transaction_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load transactions when screen initializes
    Future.microtask(
      () => ref.read(transactionNotifierProvider.notifier).loadTransactions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionNotifierProvider);
    final notifier = ref.read(transactionNotifierProvider.notifier);

    // Show error snackbar if there's an error
    ref.listen(
      transactionNotifierProvider,
      (previous, next) {
        if (next.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          notifier.clearError();
        }
      },
    );

    return Scaffold(
      appBar: GradientAppBar(
        title: 'Pencatatan Keuangan',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Skeletonizer(
        enabled: state.isLoading,
        child: RefreshIndicator(
          onRefresh: () => notifier.loadTransactions(),
          child: Column(
            children: [
              // Summary Card (with skeleton data when loading)
              SummaryCard(
                balance: state.isLoading ? 1234567.0 : state.balance,
                totalIncome: state.isLoading ? 500000.0 : state.totalIncome,
                totalExpense: state.isLoading ? 300000.0 : state.totalExpense,
              ),

              // Filter Buttons
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    FilterChipWidget(
                      label: 'Semua',
                      value: 'all',
                      selectedFilter: state.selectedFilter,
                      onFilterChanged: notifier.filterTransactions,
                    ),
                    const SizedBox(width: 8),
                    FilterChipWidget(
                      label: 'Pemasukan',
                      value: 'income',
                      selectedFilter: state.selectedFilter,
                      onFilterChanged: notifier.filterTransactions,
                    ),
                    const SizedBox(width: 8),
                    FilterChipWidget(
                      label: 'Pengeluaran',
                      value: 'expense',
                      selectedFilter: state.selectedFilter,
                      onFilterChanged: notifier.filterTransactions,
                    ),
                  ],
                ),
              ),

              // Transaction List (with skeleton items when loading)
              Expanded(
                child: state.isLoading
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: 5, // Show 5 skeleton items
                        itemBuilder: (context, index) {
                          return TransactionItem(
                            transaction: Transaction(
                              id: index,
                              title: 'Loading transaction name',
                              amount: 100000.0,
                              type: TransactionType.expense,
                              category: 'Loading',
                              date: DateTime.now(),
                            ),
                            onTap: () {},
                          );
                        },
                      )
                    : state.filteredTransactions.isEmpty
                        ? const EmptyTransactionWidget()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.filteredTransactions.length,
                            itemBuilder: (context, index) {
                              final transaction =
                                  state.filteredTransactions[index];
                              return TransactionItem(
                                transaction: transaction,
                                onTap: () {
                                  context.push(
                                    '/transaction-detail/${transaction.id}',
                                  );
                                },
                              )
                                  .animate()
                                  .fadeIn(
                                    delay: Duration(milliseconds: 50 * index),
                                    duration: 400.ms,
                                  )
                                  .slideX(
                                    begin: -0.1,
                                    end: 0,
                                    delay: Duration(milliseconds: 50 * index),
                                    duration: 400.ms,
                                    curve: Curves.easeOutCubic,
                                  );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: GradientTheme.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2196F3).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            await context.push('/add-transaction');
            // Reload transactions after returning from add screen
            notifier.loadTransactions();
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
