import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/gradient_theme.dart';
import '../../../domain/entities/spending_limit.dart';
import '../../providers/spending_limit_provider.dart';
import '../../providers/transaction_provider.dart';
import 'widgets/spending_limit_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(spendingLimitNotifierProvider.notifier).loadLimits();

      // Update current spending based on transactions
      final transactions = ref.read(transactionNotifierProvider).transactions;
      ref
          .read(spendingLimitNotifierProvider.notifier)
          .updateCurrentSpending(transactions);

      // Initialize notification service
      ref.read(notificationServiceProvider).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(spendingLimitNotifierProvider);
    final notifier = ref.read(spendingLimitNotifierProvider.notifier);

    // Listen for errors
    ref.listen(
      spendingLimitNotifierProvider,
      (previous, next) {
        if (next.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: const Color(0xFFf5576c),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          notifier.clearError();
        }
      },
    );

    return Scaffold(
      appBar: GradientAppBar(
        title: 'Pengaturan Batas',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Batas Pengeluaran',
              style: TextStyle(
                fontSize: 24.sp,
                fontFamily: 'SFBold',
              ),
            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.2, end: 0),
            SizedBox(height: 8.h),
            Text(
              'Atur batas pengeluaran harian, mingguan, dan bulanan. Anda akan menerima notifikasi saat mendekati atau melebihi batas.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                fontFamily: 'SFRegular',
              ),
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            SizedBox(height: 32.h),

            // Daily Limit Card
            SpendingLimitCard(
              period: LimitPeriod.daily,
              currentLimit: _getLimitForPeriod(state.limits, LimitPeriod.daily),
              currentSpending: state.currentSpending[LimitPeriod.daily] ?? 0,
              onSave: (limit) async {
                final success = await notifier.saveLimit(limit);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Batas harian berhasil disimpan'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              },
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 16),

            // Weekly Limit Card
            SpendingLimitCard(
              period: LimitPeriod.weekly,
              currentLimit:
                  _getLimitForPeriod(state.limits, LimitPeriod.weekly),
              currentSpending: state.currentSpending[LimitPeriod.weekly] ?? 0,
              onSave: (limit) async {
                final success = await notifier.saveLimit(limit);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Batas mingguan berhasil disimpan'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              },
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 16),

            // Monthly Limit Card
            SpendingLimitCard(
              period: LimitPeriod.monthly,
              currentLimit:
                  _getLimitForPeriod(state.limits, LimitPeriod.monthly),
              currentSpending: state.currentSpending[LimitPeriod.monthly] ?? 0,
              onSave: (limit) async {
                final success = await notifier.saveLimit(limit);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Batas bulanan berhasil disimpan'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              },
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 32),

            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF667eea).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF667eea).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: GradientTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notifikasi Otomatis',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'SFSemibold',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Peringatan saat 80% • Alert saat 100%',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontFamily: 'SFRegular',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 500.ms, duration: 300.ms)
                .slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  SpendingLimit? _getLimitForPeriod(
      List<SpendingLimit> limits, LimitPeriod period) {
    try {
      return limits.firstWhere((limit) => limit.period == period);
    } catch (e) {
      return null;
    }
  }
}
