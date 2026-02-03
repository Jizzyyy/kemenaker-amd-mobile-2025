import 'package:dartz/dartz.dart';
import '../entities/spending_limit.dart';
import '../../core/error/failures.dart';

abstract class SpendingLimitRepository {
  Future<Either<Failure, List<SpendingLimit>>> getAllLimits();
  Future<Either<Failure, SpendingLimit?>> getLimitByPeriod(LimitPeriod period);
  Future<Either<Failure, void>> setLimit(SpendingLimit limit);
  Future<Either<Failure, void>> deleteLimit(int id);
  Future<Either<Failure, void>> toggleLimit(int id, bool isEnabled);
}
