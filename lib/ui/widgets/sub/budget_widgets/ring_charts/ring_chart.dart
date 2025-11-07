import 'package:flutter/material.dart';
import 'ring_painter.dart';

class RingChart extends StatelessWidget {
  final double percent;
  final bool isNegative;

  const RingChart({super.key, required this.percent, required this.isNegative});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RingPainter(percent, isNegative, context),
      child: SizedBox(
        width: 80,
        height: 80,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Balance", style: TextStyle(fontSize: 11, color: Colors.white70)),
              Text(
                "${percent.toStringAsFixed(1)}%",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isNegative ? Colors.redAccent : Colors.greenAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
