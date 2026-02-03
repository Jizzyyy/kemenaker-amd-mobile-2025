import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<void> showWarningNotification({
    required String period,
    required double percentage,
    required double current,
    required double limit,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'spending_warning',
      'Peringatan Pengeluaran',
      channelDescription:
          'Notifikasi peringatan saat mendekati batas pengeluaran',
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xFFFFA726), // Orange
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
      enableLights: true,
      ledColor: Color(0xFFFFA726),
      ledOnMs: 1000,
      ledOffMs: 500,
      ticker: 'Peringatan Pengeluaran',
      showWhen: false,
      styleInformation: const BigTextStyleInformation(''),
      fullScreenIntent: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final periodName = _getPeriodName(period);
    final formattedCurrent = _formatCurrency(current);
    final formattedLimit = _formatCurrency(limit);

    await _notifications.show(
      1,
      '⚠️ Peringatan Pengeluaran',
      'Pengeluaran $periodName sudah ${percentage.toInt()}% ($formattedCurrent dari $formattedLimit)',
      details,
    );
  }

  Future<void> showAlertNotification({
    required String period,
    required double current,
    required double limit,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'spending_alert',
      'Batas Terlampaui',
      channelDescription: 'Notifikasi saat batas pengeluaran terlampaui',
      importance: Importance.max,
      priority: Priority.max,
      color: Color(0xFFf5576c), // Red
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
      enableLights: true,
      ledColor: Color(0xFFf5576c),
      ledOnMs: 1000,
      ledOffMs: 500,
      ticker: 'Batas Pengeluaran Terlampaui!',
      showWhen: false,
      styleInformation: const BigTextStyleInformation(''),
      fullScreenIntent: true,
      ongoing: false,
      autoCancel: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.critical,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final periodName = _getPeriodName(period);
    final formattedCurrent = _formatCurrency(current);
    final formattedLimit = _formatCurrency(limit);

    await _notifications.show(
      2,
      '🚨 Batas Terlampaui!',
      'Pengeluaran $periodName melebihi batas! ($formattedCurrent dari $formattedLimit)',
      details,
    );
  }

  String _getPeriodName(String period) {
    switch (period) {
      case 'daily':
        return 'Hari Ini';
      case 'weekly':
        return 'Minggu Ini';
      case 'monthly':
        return 'Bulan Ini';
      default:
        return period;
    }
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }
}
