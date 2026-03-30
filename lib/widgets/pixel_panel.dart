import 'package:flutter/material.dart';

class PixelPanel extends StatelessWidget {
  const PixelPanel({super.key, required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        border: Border.all(color: const Color(0xFF5D4037), width: 3),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x335D4037), blurRadius: 0, offset: Offset(5, 5)),
        ],
      ),
      child: child,
    );
  }
}
