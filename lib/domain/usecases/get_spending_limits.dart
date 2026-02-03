import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/spending_limit.dart';
import '../repositories/spending_limit_repository.dart';

class GetSpendingLimits {
  final SpendingLimitRepository repository;

  GetSpendingLimits(this.repository);

  Future<Either<Failure, List<SpendingLimit>>> call() async {
    return await repository.getAllLimits();
  }
}
