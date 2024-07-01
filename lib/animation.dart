import 'package:flutter/material.dart';

class MoonPainterWidget extends StatefulWidget {
  const MoonPainterWidget({super.key});

  @override
  State<MoonPainterWidget> createState() => _MoonPainterWidgetState();
}

class _MoonPainterWidgetState extends State<MoonPainterWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(200, 200),
          painter: MoonPainter(_controller.value),
        );
      },
    );
  }
}

class MoonPainter extends CustomPainter {
  final double animationValue;

  MoonPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 20 * animationValue - 10);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.indigo.shade100,
          Colors.indigo.shade300,
          Colors.indigo.shade600,
        ],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));


    Path path1 = Path()
      ..addOval(Rect.fromCenter(
          center: center, width: size.width, height: size.height));

    var x = 30;

    Path path2 = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(
            center.dx - x,
            center.dy - x,
          ),
          width: size.width - x,
          height: size.height - x,
        ),
      );
    canvas.drawPath(
      Path.combine(PathOperation.difference, path1, path2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}