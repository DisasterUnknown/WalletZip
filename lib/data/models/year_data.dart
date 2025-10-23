import 'month_data.dart';

class YearData {
  final String year; // e.g., "2025"
  final List<MonthData> months;

  YearData({required this.year, required this.months});

  Map<String, dynamic> toMap() => {
        'year': year,
        'months': months.map((m) => m.toMap()).toList(),
      };

  factory YearData.fromMap(Map<String, dynamic> map) => YearData(
        year: map['year'],
        months: (map['months'] as List)
            .map((m) => MonthData.fromMap(m))
            .toList(),
      );
}
