import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/transaction.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  const TransactionModel._();

  const factory TransactionModel({
    int? id,
    required String title,
    required double amount,
    required String type,
    required String category,
    required String date,
    String? description,
    String? imagePath,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  // Convert to domain entity
  Transaction toEntity() {
    return Transaction(
      id: id,
      title: title,
      amount: amount,
      type: TransactionType.fromString(type),
      category: category,
      date: DateTime.parse(date),
      description: description,
      imagePath: imagePath,
    );
  }

  // Create from domain entity
  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      title: transaction.title,
      amount: transaction.amount,
      type: transaction.type.value,
      category: transaction.category,
      date: transaction.date.toIso8601String(),
      description: transaction.description,
      imagePath: transaction.imagePath,
    );
  }

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date,
      'description': description,
      'imagePath': imagePath,
    };
  }

  // Create from Map (database)
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: map['type'] as String,
      category: map['category'] as String,
      date: map['date'] as String,
      description: map['description'] as String?,
      imagePath: map['imagePath'] as String?,
    );
  }
}
