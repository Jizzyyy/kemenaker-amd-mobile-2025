import 'package:dartz/dartz.dart';
import '../failures/failures.dart';
import '../repositories/transaction_repository.dart';

class GetTotalIncome {
  final TransactionRepository repository;

  GetTotalIncome(this.repository);

  Future<Either<Failure, double>> call() async {
    return await repository.getTotalIncome();
  }
}
