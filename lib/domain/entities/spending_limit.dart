enum LimitPeriod {
  daily,
  weekly,
  monthly;

  String get displayName {
    switch (this) {
      case LimitPeriod.daily:
        return 'Harian';
      case LimitPeriod.weekly:
        return 'Mingguan';
      case LimitPeriod.monthly:
        return 'Bulanan';
    }
  }

  String toJson() => name;

  static LimitPeriod fromJson(String json) {
    return LimitPeriod.values.firstWhere((e) => e.name == json);
  }
}

class SpendingLimit {
  final int? id;
  final LimitPeriod period;
  final double amount;
  final bool isEnabled;
  final DateTime createdAt;

  const SpendingLimit({
    this.id,
    required this.period,
    required this.amount,
    required this.isEnabled,
    required this.createdAt,
  });

  SpendingLimit copyWith({
    int? id,
    LimitPeriod? period,
    double? amount,
    bool? isEnabled,
    DateTime? createdAt,
  }) {
    return SpendingLimit(
      id: id ?? this.id,
      period: period ?? this.period,
      amount: amount ?? this.amount,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
