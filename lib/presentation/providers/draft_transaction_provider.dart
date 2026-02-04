import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/draft_transaction_local_datasource.dart';
import '../../data/repositories/draft_transaction_repository_impl.dart';
import '../../domain/repositories/draft_transaction_repository.dart';
import '../../domain/usecases/add_draft_transaction.dart';
import '../../domain/usecases/delete_draft_transaction.dart';
import '../../domain/usecases/delete_all_draft_transactions.dart';
import '../../domain/usecases/exists_draft_by_notification_key.dart';
import '../../domain/usecases/get_all_draft_transactions.dart';
import '../../domain/usecases/get_draft_transaction_by_id.dart';
import '../notifiers/draft_transaction_notifier.dart';
import '../state/draft_transaction_state.dart';
import 'transaction_provider.dart';

final draftTransactionLocalDataSourceProvider =
    Provider<DraftTransactionLocalDataSource>((ref) {
  final database = ref.watch(databaseProvider);
  return DraftTransactionLocalDataSourceImpl(database);
});

final draftTransactionRepositoryProvider =
    Provider<DraftTransactionRepository>((ref) {
  final dataSource = ref.watch(draftTransactionLocalDataSourceProvider);
  return DraftTransactionRepositoryImpl(dataSource);
});

final getAllDraftTransactionsProvider =
    Provider<GetAllDraftTransactions>((ref) {
  final repository = ref.watch(draftTransactionRepositoryProvider);
  return GetAllDraftTransactions(repository);
});

final getDraftTransactionByIdProvider =
    Provider<GetDraftTransactionById>((ref) {
  final repository = ref.watch(draftTransactionRepositoryProvider);
  return GetDraftTransactionById(repository);
});

final addDraftTransactionProvider = Provider<AddDraftTransaction>((ref) {
  final repository = ref.watch(draftTransactionRepositoryProvider);
  return AddDraftTransaction(repository);
});

final deleteDraftTransactionProvider =
    Provider<DeleteDraftTransaction>((ref) {
  final repository = ref.watch(draftTransactionRepositoryProvider);
  return DeleteDraftTransaction(repository);
});

final deleteAllDraftTransactionsProvider =
    Provider<DeleteAllDraftTransactions>((ref) {
  final repository = ref.watch(draftTransactionRepositoryProvider);
  return DeleteAllDraftTransactions(repository);
});

final existsDraftByNotificationKeyProvider =
    Provider<ExistsDraftByNotificationKey>((ref) {
  final repository = ref.watch(draftTransactionRepositoryProvider);
  return ExistsDraftByNotificationKey(repository);
});

final draftTransactionNotifierProvider =
    StateNotifierProvider<DraftTransactionNotifier, DraftTransactionState>(
        (ref) {
  return DraftTransactionNotifier(
    getAllDrafts: ref.watch(getAllDraftTransactionsProvider),
    getDraftById: ref.watch(getDraftTransactionByIdProvider),
    addDraft: ref.watch(addDraftTransactionProvider),
    deleteDraft: ref.watch(deleteDraftTransactionProvider),
    deleteAllDrafts: ref.watch(deleteAllDraftTransactionsProvider),
    existsByNotificationKey: ref.watch(existsDraftByNotificationKeyProvider),
  );
});
