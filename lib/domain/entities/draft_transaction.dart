class DraftTransaction {
  final int? id;
  final String title;
  final double amount;
  final DraftTransactionType type;
  final String category;
  final DateTime date;
  final String? description;
  final String? imagePath;
  final String sourceApp;
  final String rawText;
  final String? notificationKey;
  final DateTime createdAt;

  const DraftTransaction({
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

  DraftTransaction copyWith({
    int? id,
    String? title,
    double? amount,
    DraftTransactionType? type,
    String? category,
    DateTime? date,
    String? description,
    String? imagePath,
    String? sourceApp,
    String? rawText,
    String? notificationKey,
    DateTime? createdAt,
  }) {
    return DraftTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      sourceApp: sourceApp ?? this.sourceApp,
      rawText: rawText ?? this.rawText,
      notificationKey: notificationKey ?? this.notificationKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum DraftTransactionType {
  income,
  expense;

  String get value {
    switch (this) {
      case DraftTransactionType.income:
        return 'income';
      case DraftTransactionType.expense:
        return 'expense';
    }
  }

  static DraftTransactionType fromString(String value) {
    switch (value) {
      case 'income':
        return DraftTransactionType.income;
      case 'expense':
        return DraftTransactionType.expense;
      default:
        return DraftTransactionType.expense;
    }
  }
}
