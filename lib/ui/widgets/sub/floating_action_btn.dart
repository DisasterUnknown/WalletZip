import 'package:flutter/material.dart';

class FloatingAddBtn extends StatelessWidget {
  const FloatingAddBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white38, width: 1),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D0D0D), Color(0xFF2B2B2B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () {
          print("Square Floating + pressed!");
        },
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}
