import 'package:flutter/material.dart';
import 'dart:math' as math;

class RingPainter extends CustomPainter {
  final double percent;
  final bool isNegative;

  RingPainter(this.percent, this.isNegative);

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 8.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;

    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    final fgPaint = Paint()
      ..color = isNegative ? Colors.redAccent : Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final sweep = -(percent / 100) * 2 * math.pi;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, sweep, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
