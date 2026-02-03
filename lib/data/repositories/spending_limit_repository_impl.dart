import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/spending_limit.dart';
import '../../domain/repositories/spending_limit_repository.dart';
import '../datasources/spending_limit_local_datasource.dart';
import '../models/spending_limit_model.dart';

class SpendingLimitRepositoryImpl implements SpendingLimitRepository {
  final SpendingLimitLocalDataSource localDataSource;

  SpendingLimitRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<SpendingLimit>>> getAllLimits() async {
    try {
      final models = await localDataSource.getAllLimits();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure('Failed to get limits: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, SpendingLimit?>> getLimitByPeriod(
      LimitPeriod period) async {
    try {
      final model = await localDataSource.getLimitByPeriod(period.name);
      return Right(model?.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Failed to get limit: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> setLimit(SpendingLimit limit) async {
    try {
      final model = SpendingLimitModel.fromEntity(limit);

      // Check if limit already exists for this period
      final existing =
          await localDataSource.getLimitByPeriod(limit.period.name);

      if (existing != null) {
        // Update existing limit
        await localDataSource.updateLimit(model.copyWith(id: existing.id));
      } else {
        // Insert new limit
        await localDataSource.insertLimit(model);
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to set limit: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLimit(int id) async {
    try {
      await localDataSource.deleteLimit(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete limit: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleLimit(int id, bool isEnabled) async {
    try {
      await localDataSource.toggleLimit(id, isEnabled);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to toggle limit: ${e.toString()}'));
    }
  }
}
