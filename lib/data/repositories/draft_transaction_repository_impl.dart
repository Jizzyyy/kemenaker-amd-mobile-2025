import 'package:dartz/dartz.dart';
import '../../domain/entities/draft_transaction.dart';
import '../../domain/failures/failures.dart';
import '../../domain/repositories/draft_transaction_repository.dart';
import '../datasources/draft_transaction_local_datasource.dart';
import '../models/draft_transaction_model.dart';

class DraftTransactionRepositoryImpl implements DraftTransactionRepository {
  final DraftTransactionLocalDataSource localDataSource;

  DraftTransactionRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<DraftTransaction>>> getAllDrafts() async {
    try {
      final models = await localDataSource.getAllDrafts();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DraftTransaction>> getDraftById(int id) async {
    try {
      final model = await localDataSource.getDraftById(id);
      if (model == null) {
        return const Left(DatabaseFailure('Draft transaksi tidak ditemukan'));
      }
      return Right(model.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> addDraft(DraftTransaction draft) async {
    try {
      final model = DraftTransactionModel.fromEntity(draft);
      final id = await localDataSource.addDraft(model);
      return Right(id);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> deleteDraft(int id) async {
    try {
      final result = await localDataSource.deleteDraft(id);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> deleteAllDrafts() async {
    try {
      final result = await localDataSource.deleteAllDrafts();
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> existsByNotificationKey(String key) async {
    try {
      final exists = await localDataSource.existsByNotificationKey(key);
      return Right(exists);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
