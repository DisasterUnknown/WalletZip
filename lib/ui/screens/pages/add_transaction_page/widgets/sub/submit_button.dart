import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color accentColor;

  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: accentColor, width: 2),
        ),
      ),
      child: Text(label, style: TextStyle(color: accentColor)),
    );
  }
}
