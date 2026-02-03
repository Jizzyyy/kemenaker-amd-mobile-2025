import 'package:dartz/dartz.dart';
import '../entities/transaction.dart';
import '../failures/failures.dart';
import '../repositories/transaction_repository.dart';

class GetAllTransactions {
  final TransactionRepository repository;

  GetAllTransactions(this.repository);

  Future<Either<Failure, List<Transaction>>> call() async {
    return await repository.getAllTransactions();
  }
}
