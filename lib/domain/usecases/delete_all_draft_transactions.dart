import 'package:dartz/dartz.dart';
import '../failures/failures.dart';
import '../repositories/draft_transaction_repository.dart';

class DeleteAllDraftTransactions {
  final DraftTransactionRepository repository;

  DeleteAllDraftTransactions(this.repository);

  Future<Either<Failure, int>> call() async {
    return repository.deleteAllDrafts();
  }
}
