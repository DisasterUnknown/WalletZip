class Expense {
  final int? id;
  final String type; // "income" or "expense"
  final double price;
  final List<int> categoryIds; // multiple categories
  final String? note;
  final DateTime dateTime;
  final bool isBudgetEntry;

  /// Temporary Transaction
  final bool isTemporary; // marks if this is a temporary transaction
  final String? status; // 'open' | 'completed'
  final int? linkedTransactionId; // ID of the related transaction if completed
  final DateTime? expectedDate; // optional expected date for reimbursement

  Expense({
    this.id,
    required this.type,
    required this.price,
    required this.categoryIds,
    this.note,
    required this.dateTime,
    this.isBudgetEntry = false,
    this.isTemporary = false,
    this.status,
    this.linkedTransactionId,
    this.expectedDate,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type,
    'price': price,
    'categoryIds': categoryIds.join(','),
    'note': note,
    'dateTime': dateTime.toIso8601String(),
    'isBudgetEntry': isBudgetEntry ? 1 : 0,
    'isTemporary': isTemporary ? 1 : 0,
    'status': status,
    'linkedTransactionId': linkedTransactionId,
    'expectedDate': expectedDate?.toIso8601String(),
  };

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
    id: map['id'],
    type: map['type'],
    price: map['price'],
    categoryIds: map['categoryIds'] != null && map['categoryIds'] != ''
        ? (map['categoryIds'] as String)
              .split(',')
              .where((e) => e.isNotEmpty)
              .map(int.parse)
              .toList()
        : [],
    note: map['note'],
    dateTime: DateTime.parse(map['dateTime']),
    isBudgetEntry: map['isBudgetEntry'] == 1,
    isTemporary: map['isTemporary'] == 1,
    status: map['status'],
    linkedTransactionId: map['linkedTransactionId'],
    expectedDate: map['expectedDate'] != null
        ? DateTime.tryParse(map['expectedDate'])
        : null,
  );

  Expense copyWith({
    int? id,
    String? type,
    double? price,
    List<int>? categoryIds,
    String? note,
    DateTime? dateTime,
    int? linkedTransactionId,
    bool? isTemporary,
    DateTime? expectedDate,
    String? status,
  }) {
    return Expense(
      id: id ?? this.id,
      type: type ?? this.type,
      price: price ?? this.price,
      categoryIds: categoryIds ?? this.categoryIds,
      note: note ?? this.note,
      dateTime: dateTime ?? this.dateTime,
      linkedTransactionId: linkedTransactionId ?? this.linkedTransactionId,
      isTemporary: isTemporary ?? this.isTemporary,
      expectedDate: expectedDate ?? this.expectedDate,
      status: status ?? this.status,
    );
  }
}
