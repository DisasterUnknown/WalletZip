import 'day_data.dart';

class MonthData {
  final String month; // "Jan"
  final List<DayData> days;

  MonthData({required this.month, required this.days});

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
