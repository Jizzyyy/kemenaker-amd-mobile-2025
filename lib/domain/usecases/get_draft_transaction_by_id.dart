import 'package:dartz/dartz.dart';
import '../entities/draft_transaction.dart';
import '../failures/failures.dart';
import '../repositories/draft_transaction_repository.dart';

class GetDraftTransactionById {
  final DraftTransactionRepository repository;

  GetDraftTransactionById(this.repository);

  Future<Either<Failure, DraftTransaction>> call(int id) async {
    if (id <= 0) {
      return const Left(ValidationFailure('ID draft tidak valid'));
    }
    return repository.getDraftById(id);
  }
}
