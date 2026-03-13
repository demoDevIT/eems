import 'package:flutter/cupertino.dart';

class ChatBubblePainter extends CustomPainter {
  final Color color;
  ChatBubblePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    // Drawing the triangle at the top left
    path.moveTo(10, 0); // Start at the curve beginning
    path.lineTo(0, -10); // The tip of the triangle (pointing up/left)
    path.lineTo(60, 0); // End back on the container edge
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}