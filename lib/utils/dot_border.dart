import 'package:flutter/material.dart';
 
class DashedBorderContainer extends StatelessWidget {

  final Widget child;

  final double strokeWidth;

  final Color color;

  final double gap;

  final double dash;

  final String radius;
 
  const DashedBorderContainer({

    Key? key,

    required this.child,

    this.strokeWidth = 2,

    this.color = Colors.blue,

    this.gap = 4,

    this.dash = 6,
    
    this.radius = "0", 

  }) : super(key: key);
 
  @override

  Widget build(BuildContext context) {

    return CustomPaint(

      painter: _DashedBorderPainter(

        strokeWidth: strokeWidth,

        color: color,

        gap: gap,

        dash: dash,
        radius: radius

      ),

      child: child,

    );

  }

}
 
class _DashedBorderPainter extends CustomPainter {

  final double strokeWidth;

  final Color color;

  final double gap;

  final double dash;
  final String radius;
 
  _DashedBorderPainter({

    required this.strokeWidth,

    required this.color,

    required this.gap,

    required this.dash,
    required this.radius,

  });
 
  @override

  void paint(Canvas canvas, Size size) {

    final paint = Paint()

      ..color = color

      ..strokeWidth = strokeWidth

      ..style = PaintingStyle.stroke;
 
    final path = Path()

    ..addRRect(RRect.fromRectAndRadius(

        Offset.zero & size,

        Radius.circular(double.parse(radius)), // rounded corners

      ));
 
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {

      double distance = 0.0;

      while (distance < metric.length) {

        final segment = metric.extractPath(

          distance,

          distance + dash,

        );

        canvas.drawPath(segment, paint);

        distance += dash + gap;

      }

    }

  }
 
  @override

  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

}

 