import 'expense.dart';

class DayData {
  final String day; // e.g., "23"
  final List<Expense> expenses;

  DayData({required this.day, required this.expenses});

  Map<String, dynamic> toMap() => {
        'day': day,
        'expenses': expenses.map((e) => e.toMap()).toList(),
      };

  factory DayData.fromMap(Map<String, dynamic> map) => DayData(
        day: map['day'],
        expenses: (map['expenses'] as List)
            .map((e) => Expense.fromMap(e))
            .toList(),
      );
}
