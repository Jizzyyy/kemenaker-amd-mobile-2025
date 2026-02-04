import 'package:dartz/dartz.dart';
import '../failures/failures.dart';
import '../repositories/draft_transaction_repository.dart';

class ExistsDraftByNotificationKey {
  final DraftTransactionRepository repository;

  ExistsDraftByNotificationKey(this.repository);

  Future<Either<Failure, bool>> call(String key) async {
    if (key.trim().isEmpty) {
      return const Left(ValidationFailure('Notification key tidak valid'));
    }
    return repository.existsByNotificationKey(key);
  }
}
