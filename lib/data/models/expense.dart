class Expense {
  final int? id;
  final String type;           // "income" or "expense"
  final double price;
  final List<int> categoryIds; // multiple categories
  final String? note;
  final DateTime dateTime;

  Expense({
    this.id,
    required this.type,
    required this.price,
    required this.categoryIds,
    this.note,
    required this.dateTime,
  });

  // Convert to Map (for SQLite / JSON)
  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'price': price,
        'categoryIds': categoryIds.join(','), // store as comma-separated string in SQLite
        'note': note,
        'dateTime': dateTime.toIso8601String(),
      };

  // Create Expense from Map (SQLite / JSON)
  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
        id: map['id'],
        type: map['type'],
        price: map['price'],
        categoryIds: map['categoryIds'] != null && map['categoryIds'] != ''
            ? (map['categoryIds'] as String)
                .split(',')
                .map((e) => int.parse(e))
                .toList()
            : [],
        note: map['note'],
        dateTime: DateTime.parse(map['dateTime']),
      );
}
