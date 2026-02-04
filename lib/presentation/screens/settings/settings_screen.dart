import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/gradient_theme.dart';
import '../../../domain/entities/spending_limit.dart';
import '../../providers/spending_limit_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/theme_provider.dart';
import '../../../core/services/payment_notification_channel.dart';
import '../../../core/services/permission_service.dart';
import 'widgets/spending_limit_card.dart';
import 'widgets/permission_card.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _notificationChannel = PaymentNotificationChannel();
  final _permissionService = PermissionService();

  // Permission states
  bool _notificationGranted = false;
  bool _cameraGranted = false;
  bool _storageGranted = false;

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

      // Check permissions
      _checkPermissions();
    });
  }

  Future<void> _checkPermissions() async {
    final notification = await _permissionService.checkNotificationPermission();
    final camera = await _permissionService.checkCameraPermission();
    final storage = await _permissionService.checkStoragePermission();

    if (mounted) {
      setState(() {
        _notificationGranted = notification;
        _cameraGranted = camera;
        _storageGranted = storage;
      });
    }
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
        title: 'Pengaturan',
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

            // Theme Section
            Text(
              'Tema Aplikasi',
              style: TextStyle(
                fontSize: 24.sp,
                fontFamily: 'SFBold',
              ),
            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.2, end: 0),
            SizedBox(height: 8.h),
            Text(
              'Pilih tema yang nyaman untuk Anda',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                fontFamily: 'SFRegular',
              ),
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            SizedBox(height: 16.h),
            _buildThemeSelector(),
            SizedBox(height: 32.h),

            // Spending Limits Header
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
            const SizedBox(height: 32),

            // Permissions Section Header
            Text(
              'Perizinan Aplikasi',
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'SFBold',
              ),
            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.2, end: 0),
            SizedBox(height: 8.h),
            Text(
              'Kelola izin yang diperlukan agar aplikasi berfungsi dengan optimal',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                fontFamily: 'SFRegular',
              ),
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            SizedBox(height: 20.h),

            // Notification Permission
            PermissionCard(
              icon: Icons.notifications_active,
              title: 'Notifikasi',
              description: 'Pengingat pengeluaran & alert',
              iconGradient: GradientTheme.primaryGradient,
              themeColor: const Color(0xFF1FAB89), // Teal for notification
              onTap: () async {
                if (!_notificationGranted) {
                  final granted =
                      await _permissionService.requestNotificationPermission();
                  if (!granted) {
                    await openAppSettings();
                  }
                } else {
                  await openAppSettings();
                }
                await _checkPermissions();
              },
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            SizedBox(height: 16.h),

            // Camera Permission
            PermissionCard(
              icon: Icons.camera_alt,
              title: 'Kamera',
              description: 'Scan nota & bukti transaksi',
              iconGradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
              ),
              themeColor: const Color(0xFF4CAF50), // Green for camera
              onTap: () async {
                if (!_cameraGranted) {
                  final granted =
                      await _permissionService.requestCameraPermission();
                  if (!granted) {
                    await openAppSettings();
                  }
                } else {
                  await openAppSettings();
                }
                await _checkPermissions();
              },
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            SizedBox(height: 16.h),

            // Storage Permission
            PermissionCard(
              icon: Icons.photo_library,
              title: 'Galeri/Penyimpanan',
              description: 'Upload nota dari galeri',
              iconGradient: LinearGradient(
                colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
              ),
              themeColor: const Color(0xFFFF9800), // Orange for storage
              onTap: () async {
                if (!_storageGranted) {
                  final granted =
                      await _permissionService.requestStoragePermission();
                  if (!granted) {
                    await openAppSettings();
                  }
                } else {
                  await openAppSettings();
                }
                await _checkPermissions();
              },
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            SizedBox(height: 16.h),

            // Debug/Access Buttons Section
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.push('/notification-debug'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF2196F3).withOpacity(0.2),
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
                        Icons.bug_report,
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
                            'Diagnostik Notifikasi',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'SFSemibold',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Cek notifikasi yang tertangkap listener',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontFamily: 'SFRegular',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 300.ms)
                .slideY(begin: 0.2, end: 0),
            SizedBox(height: 16.h),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () =>
                  _notificationChannel.openNotificationAccessSettings(),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF4CAF50).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications_active,
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
                            'Akses Notifikasi Khusus',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'SFSemibold',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Buka halaman izin Notification Access',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontFamily: 'SFRegular',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 700.ms, duration: 300.ms)
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

  Widget _buildThemeSelector() {
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1e2538) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            _buildThemeOption(
              title: 'Terang',
              subtitle: 'Tema terang untuk siang hari',
              icon: Icons.light_mode,
              isSelected: themeState.themeMode == AppThemeMode.light,
              onTap: () => themeNotifier.setThemeMode(AppThemeMode.light),
              gradient: GradientTheme.primaryGradient,
            ),
            SizedBox(height: 12.h),
            _buildThemeOption(
              title: 'Gelap',
              subtitle: 'Tema gelap untuk malam hari',
              icon: Icons.dark_mode,
              isSelected: themeState.themeMode == AppThemeMode.dark,
              onTap: () => themeNotifier.setThemeMode(AppThemeMode.dark),
              gradient: GradientTheme.primaryGradientDark,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms).scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
          duration: 300.ms,
        );
  }

  Widget _buildThemeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required LinearGradient gradient,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark
              ? (isSelected ? const Color(0xFF2d3250) : const Color(0xFF252b42))
              : (isSelected ? Colors.blue.shade50 : Colors.grey.shade50),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? (isDark
                    ? const Color(0xFF4DB6AC)
                    : const Color(0xFF009688)) // Teal
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'SFSemibold',
                      color: isSelected
                          ? (isDark
                              ? const Color(0xFF2DD4BF) // Teal Pastel
                              : const Color(0xFF009688)) // Teal
                          : (isDark
                              ? const Color(0xFFF1F5F9) // Putih Gading
                              : Colors.grey.shade800),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isDark
                          ? const Color(0xFF94a3b8)
                          : Colors.grey.shade600,
                      fontFamily: 'SFRegular',
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  gradient: gradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
