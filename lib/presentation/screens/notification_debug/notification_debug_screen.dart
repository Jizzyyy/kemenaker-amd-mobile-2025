import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/payment_notification_channel.dart';
import '../../../core/services/payment_notification_importer.dart';
import '../../../core/theme/gradient_theme.dart';

class NotificationDebugScreen extends ConsumerStatefulWidget {
  const NotificationDebugScreen({super.key});

  @override
  ConsumerState<NotificationDebugScreen> createState() =>
      _NotificationDebugScreenState();
}

class _NotificationDebugScreenState
    extends ConsumerState<NotificationDebugScreen> {
  final _channel = PaymentNotificationChannel();
  late final PaymentNotificationImporter _importer;
  List<RawNotificationPayload> _payloads = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _importer = PaymentNotificationImporter(channel: _channel);
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final payloads = await _channel.peekPendingNotifications();
    setState(() {
      _payloads = payloads;
      _isLoading = false;
    });
  }

  Future<void> _importNow() async {
    setState(() => _isLoading = true);
    final imported = await _importer.importPending(ref);
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berhasil import $imported notifikasi'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _clearQueue() async {
    await _channel.clearPendingNotifications();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Diagnostik Notifikasi'),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildActions(),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_payloads.isEmpty)
              _buildEmpty()
            else
              ..._payloads.map(_buildCard),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: _importNow,
            child: const Text(
              'Import Sekarang',
              style: TextStyle(
                fontFamily: 'SFSemibold',
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          onPressed: _clearQueue,
          child: const Text(
            'Bersihkan',
            style: TextStyle(fontFamily: 'SFSemibold'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF667eea).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF667eea).withOpacity(0.2),
        ),
      ),
      child: const Text(
        'Belum ada notifikasi yang tertangkap. Pastikan Notification Access aktif dan coba lakukan transaksi lalu buka aplikasi ini.',
        style: TextStyle(fontFamily: 'SFRegular'),
      ),
    );
  }

  Widget _buildCard(RawNotificationPayload payload) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              payload.title,
              style: const TextStyle(fontFamily: 'SFSemibold', fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              payload.text,
              style: const TextStyle(fontFamily: 'SFRegular'),
            ),
            const SizedBox(height: 8),
            Text(
              payload.packageName,
              style: TextStyle(
                fontFamily: 'SFRegular',
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
