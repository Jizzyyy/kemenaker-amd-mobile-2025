import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/payment_notification_parser.dart';
import 'payment_notification_channel.dart';
import '../../presentation/providers/draft_transaction_provider.dart';

class PaymentNotificationImporter {
  final PaymentNotificationChannel channel;

  const PaymentNotificationImporter({
    required this.channel,
  });

  Future<int> importPending(WidgetRef ref) async {
    final pending = await channel.getPendingNotifications();
    if (pending.isEmpty) return 0;

    final notifier = ref.read(draftTransactionNotifierProvider.notifier);
    int imported = 0;

    for (final item in pending) {
      final draft = PaymentNotificationParser.parse(item);
      if (draft == null) continue;
      final success = await notifier.addNewDraft(draft);
      if (success) imported += 1;
    }

    if (imported > 0) {
      await notifier.loadDrafts();
    }

    return imported;
  }
}
