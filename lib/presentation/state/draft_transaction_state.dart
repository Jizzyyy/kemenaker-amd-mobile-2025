import '../../domain/entities/draft_transaction.dart';

class DraftTransactionState {
  final List<DraftTransaction> drafts;
  final bool isLoading;
  final String? errorMessage;

  const DraftTransactionState({
    this.drafts = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  DraftTransactionState copyWith({
    List<DraftTransaction>? drafts,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DraftTransactionState(
      drafts: drafts ?? this.drafts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
