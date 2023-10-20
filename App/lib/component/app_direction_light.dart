import 'package:flutter/material.dart';
import 'dart:math' as math;

class AppDirectionLight extends StatelessWidget {
  const AppDirectionLight({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Painter(),
      size: Size(100, 50 * math.sqrt(3)),
    );
  }
}

class Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.blue.shade600);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
