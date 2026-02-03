import 'package:dartz/dartz.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/failures/failures.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Transaction>>> getAllTransactions() async {
    try {
      final models = await localDataSource.getAllTransactions();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(int id) async {
    try {
      final model = await localDataSource.getTransactionById(id);
      if (model == null) {
        return const Left(DatabaseFailure('Transaksi tidak ditemukan'));
      }
      return Right(model.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> addTransaction(Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      final id = await localDataSource.addTransaction(model);
      return Right(id);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> updateTransaction(
      Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      final result = await localDataSource.updateTransaction(model);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> deleteTransaction(int id) async {
    try {
      final result = await localDataSource.deleteTransaction(id);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalIncome() async {
    try {
      final transactions =
          await localDataSource.getTransactionsByType('income');
      final total = transactions.fold<double>(
        0.0,
        (sum, transaction) => sum + transaction.amount,
      );
      return Right(total);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalExpense() async {
    try {
      final transactions =
          await localDataSource.getTransactionsByType('expense');
      final total = transactions.fold<double>(
        0.0,
        (sum, transaction) => sum + transaction.amount,
      );
      return Right(total);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getBalance() async {
    try {
      final incomeResult = await getTotalIncome();
      final expenseResult = await getTotalExpense();

      return incomeResult.fold(
        (failure) => Left(failure),
        (income) => expenseResult.fold(
          (failure) => Left(failure),
          (expense) => Right(income - expense),
        ),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
