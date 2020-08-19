import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'dart:math';

class AnimatedWave extends StatelessWidget {
  final double height;
  final double speed;
  final double offset;
  final Widget child;
  final bool top;
  final bool reverse;
  final int alpha;

  AnimatedWave(
      {this.height,
      this.speed,
      this.offset = 0.0,
      this.child,
      this.top = true,
      this.reverse = false,
      this.alpha = 40});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: constraints.biggest.width,
          child: LoopAnimation(
            child: child,
            duration: Duration(milliseconds: (5000 / speed).round()),
            tween: Tween(begin: 0.0, end: (reverse ? -2 : 2) * pi),
            builder: (context, child, value) {
              return CustomPaint(
                foregroundPainter: top
                    ? CurvePainter(value + offset, height, alpha: alpha)
                    : BottomCurvePainter(value + offset, height,
                        MediaQuery.of(context).size.height - height,
                        alpha: alpha),
                child: child,
              );
            },
          ),
        );
      },
    );
  }
}

class CurvePainter extends CustomPainter {
  final double value;
  final double height;
  final bool top;
  final int alpha;

  CurvePainter(this.value, this.height, {this.top = true, this.alpha = 40});

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withAlpha(alpha);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = height * (0.5 + 0.4 * y1);
    final controlPointY = height * (0.5 + 0.4 * y2);
    final endPointY = height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class BottomCurvePainter extends CustomPainter {
  final double value;
  final double height;
  final int alpha;
  final double verticalOffset;

  BottomCurvePainter(this.value, this.height, this.verticalOffset,
      {this.alpha = 40});

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withAlpha(alpha);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = height * (0.5 + 0.4 * y1) + verticalOffset;
    final controlPointY = height * (0.5 + 0.4 * y2) + verticalOffset;
    final endPointY = height * (0.5 + 0.4 * y3) + verticalOffset;

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(size.width * 0.5, controlPointY,
        size.width, endPointY);
    path.lineTo(size.width, height + verticalOffset);
    path.lineTo(0, height + verticalOffset);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
