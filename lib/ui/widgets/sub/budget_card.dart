import 'package:expenso/ui/widgets/sub/ring_charts/ring_chart.dart';
import 'package:flutter/material.dart';

class BudgetCardGlass extends StatelessWidget {
  final String title;
  final double budget;
  final double spent;

  const BudgetCardGlass({
    super.key,
    required this.title,
    required this.budget,
    required this.spent,
  });

  @override
  Widget build(BuildContext context) {
    final balance = budget - spent;
    final double percent = (balance / budget) * 100;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          RingChart(percent: percent, isNegative: balance < 0),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _line("Balance:", balance),
                _divider(),
                _line("Budget:", budget),
                _line("Spent:", spent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(String label, double value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(value.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      );

  Widget _divider() => Container(height: 1, margin: const EdgeInsets.symmetric(vertical: 4), color: Colors.white24);
}
