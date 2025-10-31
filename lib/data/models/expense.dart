class Expense {
  final int? id;
  final String type; // "income" or "expense"
  final double price;
  final List<int> categoryIds; // multiple categories
  final String? note;
  final DateTime dateTime;
  final bool isBudgetEntry;

  Expense({
    this.id,
    required this.type,
    required this.price,
    required this.categoryIds,
    this.note,
    required this.dateTime,
    this.isBudgetEntry = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'price': price,
        'categoryIds': categoryIds.join(','), // comma-separated string
        'note': note,
        'dateTime': dateTime.toIso8601String(),
        'isBudgetEntry': isBudgetEntry ? 1 : 0,
      };

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
        id: map['id'],
        type: map['type'],
        price: map['price'],
        categoryIds: map['categoryIds'] != null && map['categoryIds'] != ''
            ? (map['categoryIds'] as String).split(',').map(int.parse).toList()
            : [],
        note: map['note'],
        dateTime: DateTime.parse(map['dateTime']),
        isBudgetEntry: map['isBudgetEntry'] == 1, 
      );
}
