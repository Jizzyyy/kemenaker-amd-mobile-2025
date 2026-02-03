import 'package:dartz/dartz.dart';
import '../entities/transaction.dart';
import '../failures/failures.dart';
import '../repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  Future<Either<Failure, int>> call(Transaction transaction) async {
    // Validation
    if (transaction.title.trim().isEmpty) {
      return const Left(ValidationFailure('Judul tidak boleh kosong'));
    }
    if (transaction.amount <= 0) {
      return const Left(ValidationFailure('Jumlah harus lebih dari 0'));
    }
    if (transaction.category.trim().isEmpty) {
      return const Left(ValidationFailure('Kategori harus dipilih'));
    }

    return await repository.addTransaction(transaction);
  }
}
