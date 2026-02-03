import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/spending_limit.dart';
import '../repositories/spending_limit_repository.dart';

class SetSpendingLimit {
  final SpendingLimitRepository repository;

  SetSpendingLimit(this.repository);

  Future<Either<Failure, void>> call(SpendingLimit limit) async {
    return await repository.setLimit(limit);
  }
}
