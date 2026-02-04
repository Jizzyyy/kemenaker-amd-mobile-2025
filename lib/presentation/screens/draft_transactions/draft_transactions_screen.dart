import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/gradient_theme.dart';
import '../../providers/draft_transaction_provider.dart';
import '../../notifiers/draft_transaction_notifier.dart';
import 'widgets/draft_transaction_item.dart';
import 'widgets/empty_draft_widget.dart';

class DraftTransactionsScreen extends ConsumerStatefulWidget {
  const DraftTransactionsScreen({super.key});

  @override
  ConsumerState<DraftTransactionsScreen> createState() =>
      _DraftTransactionsScreenState();
}

class _DraftTransactionsScreenState
    extends ConsumerState<DraftTransactionsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(draftTransactionNotifierProvider.notifier).loadDrafts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(draftTransactionNotifierProvider);
    final notifier = ref.read(draftTransactionNotifierProvider.notifier);

    ref.listen(
      draftTransactionNotifierProvider,
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
      appBar: const GradientAppBar(title: 'Draft Transaksi'),
      body: RefreshIndicator(
        onRefresh: () => notifier.loadDrafts(),
        child: state.drafts.isEmpty
            ? const EmptyDraftWidget()
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.drafts.length,
                itemBuilder: (context, index) {
                  final draft = state.drafts[index];
                  return DraftTransactionItem(
                    draft: draft,
                    onReview: () async {
                      await context.push('/add-transaction?draftId=${draft.id}');
                      if (!mounted) return;
                      notifier.loadDrafts();
                    },
                    onDelete: () => _confirmDelete(context, draft.id!, notifier),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    int id,
    DraftTransactionNotifier notifier,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Hapus draft',
            style: TextStyle(fontFamily: 'SFSemibold'),
          ),
          content: const Text(
            'Draft ini akan dihapus. Lanjutkan?',
            style: TextStyle(fontFamily: 'SFRegular'),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Hapus',
                style: TextStyle(color: Color(0xFFf5576c)),
              ),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await notifier.removeDraft(id);
      await notifier.loadDrafts();
    }
  }
}
