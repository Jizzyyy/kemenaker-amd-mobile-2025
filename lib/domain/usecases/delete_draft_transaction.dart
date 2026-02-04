import 'package:dartz/dartz.dart';
import '../failures/failures.dart';
import '../repositories/draft_transaction_repository.dart';

class DeleteDraftTransaction {
  final DraftTransactionRepository repository;

  DeleteDraftTransaction(this.repository);

  Future<Either<Failure, int>> call(int id) async {
    if (id <= 0) {
      return const Left(ValidationFailure('ID draft tidak valid'));
    }
    return repository.deleteDraft(id);
  }
}
