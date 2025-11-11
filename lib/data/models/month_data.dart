import 'package:expenso/data/models/budget.dart';

import 'day_data.dart';

class MonthData {
  final String month; // e.g., "January"
  final List<DayData> days;
  Budget? budget;

  MonthData({required this.month, required this.days, this.budget});

  Map<String, dynamic> toMap() => {
        'month': month,
        'days': days.map((d) => d.toMap()).toList(),
      };

  factory MonthData.fromMap(Map<String, dynamic> map) => MonthData(
        month: map['month'],
        days: (map['days'] as List)
            .map((d) => DayData.fromMap(d))
            .toList(),
      );
}
