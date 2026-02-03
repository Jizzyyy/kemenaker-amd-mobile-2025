import 'package:dartz/dartz.dart';
import '../entities/transaction.dart';
import '../failures/failures.dart';
import '../repositories/transaction_repository.dart';

class UpdateTransaction {
  final TransactionRepository repository;

  UpdateTransaction(this.repository);

  Future<Either<Failure, int>> call(Transaction transaction) async {
    // Validation
    if (transaction.id == null) {
      return const Left(ValidationFailure('ID transaksi tidak valid'));
    }
    if (transaction.title.trim().isEmpty) {
      return const Left(ValidationFailure('Judul tidak boleh kosong'));
    }
    if (transaction.amount <= 0) {
      return const Left(ValidationFailure('Jumlah harus lebih dari 0'));
    }
    if (transaction.category.trim().isEmpty) {
      return const Left(ValidationFailure('Kategori harus dipilih'));
    }

    return await repository.updateTransaction(transaction);
  }
}
