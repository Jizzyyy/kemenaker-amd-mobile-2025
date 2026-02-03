import 'package:dartz/dartz.dart';
import '../failures/failures.dart';
import '../repositories/transaction_repository.dart';

class GetTotalExpense {
  final TransactionRepository repository;

  GetTotalExpense(this.repository);

  Future<Either<Failure, double>> call() async {
    return await repository.getTotalExpense();
  }
}
