import 'package:flutter/services.dart';

class RawNotificationPayload {
  final String packageName;
  final String title;
  final String text;
  final DateTime postedAt;
  final String notificationKey;

  const RawNotificationPayload({
    required this.packageName,
    required this.title,
    required this.text,
    required this.postedAt,
    required this.notificationKey,
  });

  factory RawNotificationPayload.fromMap(Map<dynamic, dynamic> map) {
    return RawNotificationPayload(
      packageName: map['packageName'] as String? ?? '',
      title: map['title'] as String? ?? '',
      text: map['text'] as String? ?? '',
      postedAt: DateTime.fromMillisecondsSinceEpoch(
        (map['postedAt'] as int?) ?? 0,
      ),
      notificationKey: map['notificationKey'] as String? ?? '',
    );
  }
}

class PaymentNotificationChannel {
  static const MethodChannel _channel =
      MethodChannel('payment_notification_listener');

  Future<List<RawNotificationPayload>> getPendingNotifications() async {
    final result = await _channel.invokeMethod<List<dynamic>>(
      'getPendingNotifications',
    );
    if (result == null) return [];
    return result
        .whereType<Map<dynamic, dynamic>>()
        .map(RawNotificationPayload.fromMap)
        .toList();
  }

  Future<List<RawNotificationPayload>> peekPendingNotifications() async {
    final result = await _channel.invokeMethod<List<dynamic>>(
      'peekPendingNotifications',
    );
    if (result == null) return [];
    return result
        .whereType<Map<dynamic, dynamic>>()
        .map(RawNotificationPayload.fromMap)
        .toList();
  }

  Future<void> clearPendingNotifications() async {
    await _channel.invokeMethod('clearPendingNotifications');
  }

  Future<void> openNotificationAccessSettings() async {
    await _channel.invokeMethod('openNotificationAccessSettings');
  }
}
