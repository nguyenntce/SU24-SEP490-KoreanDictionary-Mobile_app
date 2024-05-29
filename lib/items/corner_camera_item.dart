import 'package:flutter/material.dart';

class CornerDashedBorderPainterCamera extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashLength = size.width * 0.3; // Tính chiều dài đường kẻ dựa trên chiều rộng container
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6;

    // Top-left corner
    canvas.drawLine(Offset(0, 0), Offset(dashLength, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, dashLength), paint);

    // Top-right corner
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - dashLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, dashLength), paint);

    // Bottom-left corner
    canvas.drawLine(Offset(0, size.height), Offset(dashLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - dashLength), paint);

    // Bottom-right corner
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - dashLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - dashLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}