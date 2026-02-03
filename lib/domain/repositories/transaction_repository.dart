import 'package:dartz/dartz.dart';
import '../entities/transaction.dart';
import '../failures/failures.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getAllTransactions();
  Future<Either<Failure, Transaction>> getTransactionById(int id);
  Future<Either<Failure, int>> addTransaction(Transaction transaction);
  Future<Either<Failure, int>> updateTransaction(Transaction transaction);
  Future<Either<Failure, int>> deleteTransaction(int id);
  Future<Either<Failure, double>> getTotalIncome();
  Future<Either<Failure, double>> getTotalExpense();
  Future<Either<Failure, double>> getBalance();
}
