import 'package:dartz/dartz.dart';
import '../failures/failures.dart';
import '../repositories/transaction_repository.dart';

class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction(this.repository);

  Future<Either<Failure, int>> call(int id) async {
    if (id <= 0) {
      return const Left(ValidationFailure('ID transaksi tidak valid'));
    }
    return await repository.deleteTransaction(id);
  }
}
