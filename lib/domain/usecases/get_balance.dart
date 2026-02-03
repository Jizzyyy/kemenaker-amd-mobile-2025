import 'package:dartz/dartz.dart';
import '../failures/failures.dart';
import '../repositories/transaction_repository.dart';

class GetBalance {
  final TransactionRepository repository;

  GetBalance(this.repository);

  Future<Either<Failure, double>> call() async {
    return await repository.getBalance();
  }
}
