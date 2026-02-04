import 'package:dartz/dartz.dart';
import '../entities/draft_transaction.dart';
import '../failures/failures.dart';
import '../repositories/draft_transaction_repository.dart';

class GetAllDraftTransactions {
  final DraftTransactionRepository repository;

  GetAllDraftTransactions(this.repository);

  Future<Either<Failure, List<DraftTransaction>>> call() async {
    return repository.getAllDrafts();
  }
}
