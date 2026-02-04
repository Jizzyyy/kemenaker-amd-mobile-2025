import 'package:dartz/dartz.dart';
import '../entities/draft_transaction.dart';
import '../failures/failures.dart';
import '../repositories/draft_transaction_repository.dart';

class AddDraftTransaction {
  final DraftTransactionRepository repository;

  AddDraftTransaction(this.repository);

  Future<Either<Failure, int>> call(DraftTransaction draft) async {
    if (draft.title.trim().isEmpty) {
      return const Left(ValidationFailure('Judul draft tidak valid'));
    }
    if (draft.amount <= 0) {
      return const Left(ValidationFailure('Jumlah draft tidak valid'));
    }
    if (draft.category.trim().isEmpty) {
      return const Left(ValidationFailure('Kategori draft tidak valid'));
    }
    return repository.addDraft(draft);
  }
}
