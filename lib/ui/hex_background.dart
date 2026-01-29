import 'dart:math';
import 'package:flutter/material.dart';

class HexBackground extends StatelessWidget {
  const HexBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HexPainter(),
      size: Size.infinite,
    );
  }
}

class _HexPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withOpacity(0.06);

    const hexSize = 26.0;
    final hexHeight = hexSize * 2;
    final hexWidth = sqrt(3) * hexSize;

    for (double y = 0; y < size.height; y += hexHeight * 0.75) {
      for (double x = 0; x < size.width; x += hexWidth) {
        final offsetX =
            ((y ~/ (hexHeight * 0.75)) % 2) * (hexWidth / 2);
        _drawHex(canvas, paint, Offset(x + offsetX, y), hexSize);
      }
    }
  }

  void _drawHex(Canvas canvas, Paint paint, Offset center, double r) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = pi / 3 * i;
      final point = Offset(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}