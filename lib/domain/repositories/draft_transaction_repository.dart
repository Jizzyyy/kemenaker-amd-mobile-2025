import 'package:dartz/dartz.dart';
import '../entities/draft_transaction.dart';
import '../failures/failures.dart';

abstract class DraftTransactionRepository {
  Future<Either<Failure, List<DraftTransaction>>> getAllDrafts();
  Future<Either<Failure, DraftTransaction>> getDraftById(int id);
  Future<Either<Failure, int>> addDraft(DraftTransaction draft);
  Future<Either<Failure, int>> deleteDraft(int id);
  Future<Either<Failure, int>> deleteAllDrafts();
  Future<Either<Failure, bool>> existsByNotificationKey(String key);
}
