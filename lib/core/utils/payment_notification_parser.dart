import '../../domain/entities/draft_transaction.dart';
import '../services/payment_notification_channel.dart';

class PaymentNotificationParser {
  static const List<String> _supportedKeywords = [
    'ovo',
    'dana',
    'gojek',
    'gopay',
    'livin',
    'mandiri',
    'seabank',
  ];

  static DraftTransaction? parse(RawNotificationPayload payload) {
    final sourceApp = _resolveSourceApp(payload.packageName, payload.title);
    final combined = '${payload.title} ${payload.text}'.toLowerCase();
    if (!_looksLikePayment(combined)) return null;

    final amount = _extractAmount(combined);
    if (amount == null || amount <= 0) return null;

    final type = _detectType(combined);
    final merchant = _extractMerchant(payload.text) ?? _extractMerchant(payload.title);
    final resolvedSource = sourceApp ?? _fallbackSourceName(payload.packageName);

    return DraftTransaction(
      title: merchant?.trim().isNotEmpty == true
          ? merchant!.trim()
          : _defaultTitle(type, resolvedSource, combined),
      amount: amount,
      type: type,
      category: type == DraftTransactionType.income ? 'Lainnya' : 'Belanja',
      date: payload.postedAt,
      description: payload.text.trim().isEmpty ? null : payload.text.trim(),
      imagePath: null,
      sourceApp: resolvedSource,
      rawText: '${payload.title}\n${payload.text}'.trim(),
      notificationKey:
          payload.notificationKey.trim().isEmpty ? null : payload.notificationKey,
      createdAt: DateTime.now(),
    );
  }

  static String? _resolveSourceApp(String packageName, String title) {
    final lower = packageName.toLowerCase();
    if (_supportedKeywords.any(lower.contains)) {
      return _prettySourceName(lower);
    }

    final titleLower = title.toLowerCase();
    if (_supportedKeywords.any(titleLower.contains)) {
      return _prettySourceName(titleLower);
    }

    return null;
  }

  static String _fallbackSourceName(String packageName) {
    if (packageName.trim().isEmpty) return 'Pembayaran';
    return packageName.split('.').last;
  }

  static String _defaultTitle(
    DraftTransactionType type,
    String source,
    String text,
  ) {
    if (text.contains('transfer')) {
      return type == DraftTransactionType.income
          ? '$source - Transfer Masuk'
          : '$source - Transfer Keluar';
    }
    return '$source - Transaksi';
  }

  static String _prettySourceName(String value) {
    if (value.contains('ovo')) return 'OVO';
    if (value.contains('gopay') || value.contains('gojek')) return 'GoPay';
    if (value.contains('dana')) return 'DANA';
    if (value.contains('livin') || value.contains('mandiri')) return 'Livin Mandiri';
    if (value.contains('seabank')) return 'SeaBank';
    return 'Pembayaran';
  }

  static bool _looksLikePayment(String text) {
    final keywords = [
      'pembayaran',
      'transaksi',
      'berhasil',
      'didebit',
      'debit',
      'transfer',
      'keluar',
      'masuk',
      'real-time',
      'realtime',
      'kirim',
      'tarik',
      'terima',
      'kredit',
      'top up',
      'topup',
    ];

    final hasAmount = text.contains('rp') || text.contains('idr');
    return hasAmount && keywords.any(text.contains);
  }

  static double? _extractAmount(String text) {
    final regex = RegExp(r'(rp|idr)\s?([0-9\.,]+)', caseSensitive: false);
    final match = regex.firstMatch(text);
    if (match == null) return null;
    final raw = match.group(2) ?? '';
    String normalized = raw;
    if (raw.contains('.') && raw.contains(',')) {
      normalized = raw.replaceAll('.', '').replaceAll(',', '.');
    } else if (raw.contains(',')) {
      final parts = raw.split(',');
      if (parts.length == 2 && parts[1].length == 3) {
        normalized = raw.replaceAll(',', '');
      } else {
        normalized = raw.replaceAll(',', '.');
      }
    } else {
      normalized = raw.replaceAll('.', '');
    }
    return double.tryParse(normalized);
  }

  static DraftTransactionType _detectType(String text) {
    if (text.contains('masuk') || text.contains('terima') || text.contains('kredit')) {
      return DraftTransactionType.income;
    }
    return DraftTransactionType.expense;
  }

  static String? _extractMerchant(String text) {
    final patterns = [
      RegExp(r'ke\s+([a-zA-Z0-9\s\.\-]+)', caseSensitive: false),
      RegExp(r'untuk\s+([a-zA-Z0-9\s\.\-]+)', caseSensitive: false),
      RegExp(r'di\s+([a-zA-Z0-9\s\.\-]+)', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final value = match.group(1)?.trim();
        if (value != null && value.isNotEmpty) {
          return value.split(' berhasil').first.trim();
        }
      }
    }
    return null;
  }
}
