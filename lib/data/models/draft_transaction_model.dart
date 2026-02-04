import '../../domain/entities/draft_transaction.dart';

class DraftTransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String type;
  final String category;
  final String date;
  final String? description;
  final String? imagePath;
  final String sourceApp;
  final String rawText;
  final String? notificationKey;
  final String createdAt;

  const DraftTransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.description,
    this.imagePath,
    required this.sourceApp,
    required this.rawText,
    this.notificationKey,
    required this.createdAt,
  });

  DraftTransaction toEntity() {
    return DraftTransaction(
      id: id,
      title: title,
      amount: amount,
      type: DraftTransactionType.fromString(type),
      category: category,
      date: DateTime.parse(date),
      description: description,
      imagePath: imagePath,
      sourceApp: sourceApp,
      rawText: rawText,
      notificationKey: notificationKey,
      createdAt: DateTime.parse(createdAt),
    );
  }

  factory DraftTransactionModel.fromEntity(DraftTransaction draft) {
    return DraftTransactionModel(
      id: draft.id,
      title: draft.title,
      amount: draft.amount,
      type: draft.type.value,
      category: draft.category,
      date: draft.date.toIso8601String(),
      description: draft.description,
      imagePath: draft.imagePath,
      sourceApp: draft.sourceApp,
      rawText: draft.rawText,
      notificationKey: draft.notificationKey,
      createdAt: draft.createdAt.toIso8601String(),
    );
  }

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
      'source_app': sourceApp,
      'raw_text': rawText,
      'notification_key': notificationKey,
      'created_at': createdAt,
    };
  }

  factory DraftTransactionModel.fromMap(Map<String, dynamic> map) {
    return DraftTransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: map['type'] as String,
      category: map['category'] as String,
      date: map['date'] as String,
      description: map['description'] as String?,
      imagePath: map['imagePath'] as String?,
      sourceApp: map['source_app'] as String,
      rawText: map['raw_text'] as String,
      notificationKey: map['notification_key'] as String?,
      createdAt: map['created_at'] as String,
    );
  }
}
