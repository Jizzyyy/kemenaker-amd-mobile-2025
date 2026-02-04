import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/draft_transaction.dart';
import '../../domain/usecases/add_draft_transaction.dart';
import '../../domain/usecases/delete_draft_transaction.dart';
import '../../domain/usecases/delete_all_draft_transactions.dart';
import '../../domain/usecases/get_all_draft_transactions.dart';
import '../../domain/usecases/get_draft_transaction_by_id.dart';
import '../../domain/usecases/exists_draft_by_notification_key.dart';
import '../state/draft_transaction_state.dart';

class DraftTransactionNotifier
    extends StateNotifier<DraftTransactionState> {
  final GetAllDraftTransactions getAllDrafts;
  final GetDraftTransactionById getDraftById;
  final AddDraftTransaction addDraft;
  final DeleteDraftTransaction deleteDraft;
  final DeleteAllDraftTransactions deleteAllDrafts;
  final ExistsDraftByNotificationKey existsByNotificationKey;

  DraftTransactionNotifier({
    required this.getAllDrafts,
    required this.getDraftById,
    required this.addDraft,
    required this.deleteDraft,
    required this.deleteAllDrafts,
    required this.existsByNotificationKey,
  }) : super(const DraftTransactionState());

  Future<void> loadDrafts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await getAllDrafts();
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (drafts) => state = state.copyWith(
        drafts: drafts,
        isLoading: false,
        errorMessage: null,
      ),
    );
  }

  Future<DraftTransaction?> fetchDraftById(int id) async {
    final result = await getDraftById(id);
    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return null;
      },
      (draft) => draft,
    );
  }

  Future<bool> addNewDraft(DraftTransaction draft) async {
    if (draft.notificationKey != null &&
        draft.notificationKey!.trim().isNotEmpty) {
      final existsResult =
          await existsByNotificationKey(draft.notificationKey!);
      final exists = existsResult.fold(
        (failure) {
          state = state.copyWith(errorMessage: failure.message);
          return false;
        },
        (value) => value,
      );
      if (exists) {
        return false;
      }
    }

    final result = await addDraft(draft);
    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (_) => true,
    );
  }

  Future<bool> removeDraft(int id) async {
    final result = await deleteDraft(id);
    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (_) => true,
    );
  }

  Future<void> clearAllDrafts() async {
    await deleteAllDrafts();
    await loadDrafts();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
