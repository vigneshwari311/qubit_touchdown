import 'dart:math' as math;
import 'package:flutter/material.dart';

class BoardLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Offset nPlus = Offset(w * 0.50, h * 0.12);
    final Offset nZero = Offset(w * 0.24, h * 0.37);
    final Offset nMinusI = Offset(w * 0.76, h * 0.37);
    final Offset nI = Offset(w * 0.24, h * 0.63);
    final Offset nOne = Offset(w * 0.76, h * 0.63);
    final Offset nMinus = Offset(w * 0.50, h * 0.88);

    const double nodeRadius = 28.0;

    final Paint linePaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2.2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final Paint arrowPaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2.2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // Outer Diamond (Beside Line)
    _drawPlainLine(canvas, linePaint, nZero, nPlus, nodeRadius);
    _drawGateLabel(canvas, nZero, nPlus, 'H', side: LabelSide.left, offset: 18);

    _drawArrowLine(canvas, arrowPaint, nMinusI, nPlus, nodeRadius);
    _drawGateLabel(
      canvas,
      nMinusI,
      nPlus,
      'S',
      side: LabelSide.right,
      offset: 18,
    );

    _drawArrowLine(canvas, arrowPaint, nI, nMinus, nodeRadius);
    _drawGateLabel(canvas, nI, nMinus, 'S', side: LabelSide.left, offset: 18);

    _drawPlainLine(canvas, linePaint, nOne, nMinus, nodeRadius);
    _drawGateLabel(
      canvas,
      nOne,
      nMinus,
      'H',
      side: LabelSide.right,
      offset: 18,
    );

    _drawPlainLine(canvas, linePaint, nZero, nOne, nodeRadius);
    _drawGateLabel(
      canvas,
      nZero,
      nOne,
      'X, Y',
      customMid: Offset.lerp(nZero, nOne, 0.22),
      offset: 0,
    );
    _drawGateLabel(
      canvas,
      nZero,
      nOne,
      'X, Y',
      customMid: Offset.lerp(nZero, nOne, 0.78),
      offset: 0,
    );

    _drawPlainLine(canvas, linePaint, nMinusI, nI, nodeRadius);
    _drawGateLabel(
      canvas,
      nMinusI,
      nI,
      'X, Z, H',
      customMid: Offset.lerp(nMinusI, nI, 0.22),
      offset: 0,
    );
    _drawGateLabel(
      canvas,
      nMinusI,
      nI,
      'X, Z, H',
      customMid: Offset.lerp(nMinusI, nI, 0.78),
      offset: 0,
    );

    //  Edges with Arrows (Beside Line)
    _drawArrowLine(canvas, arrowPaint, nZero, nMinusI, nodeRadius);
    _drawGateLabel(
      canvas,
      nZero,
      nMinusI,
      '√X',
      side: LabelSide.top,
      offset: 15,
    );

    _drawArrowLine(canvas, arrowPaint, nOne, nI, nodeRadius);
    _drawGateLabel(canvas, nOne, nI, '√X', side: LabelSide.bottom, offset: 15);

    _drawArrowLine(canvas, arrowPaint, nI, nZero, nodeRadius);
    _drawGateLabel(canvas, nI, nZero, '√X', side: LabelSide.left, offset: 15);

    _drawArrowLine(canvas, arrowPaint, nMinusI, nOne, nodeRadius);
    _drawGateLabel(
      canvas,
      nMinusI,
      nOne,
      '√X',
      side: LabelSide.right,
      offset: 15,
    );
  }

  void _drawGateLabel(
    Canvas canvas,
    Offset from,
    Offset to,
    String text, {
    LabelSide side = LabelSide.left,
    double offset = 0.0,
    Offset? customMid,
  }) {
    final Offset mid =
        customMid ?? Offset((from.dx + to.dx) / 2, (from.dy + to.dy) / 2);
    final Offset dir = to - from;
    final double angle = dir.direction;

    final Offset perp = Offset(-dir.dy / dir.distance, dir.dx / dir.distance);
    final double sign =
        (side == LabelSide.right || side == LabelSide.bottom) ? 1.0 : -1.0;
    final Offset labelPos = mid + perp * offset * sign;

    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: offset == 0 ? " $text " : text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF5C518),
          fontFamily: 'Georgia',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(labelPos.dx, labelPos.dy);

    // Rotate text to match line slant
    double rotationAngle = angle;
    if (rotationAngle > math.pi / 2 || rotationAngle < -math.pi / 2) {
      rotationAngle += math.pi;
    }
    canvas.rotate(rotationAngle);

    if (offset == 0) {
      final Rect backgroundBox = Rect.fromCenter(
        center: Offset.zero,
        width: tp.width,
        height: tp.height * 0.9,
      );
      canvas.drawRect(backgroundBox, Paint()..color = Colors.black);
    } else {
      _paintTextOutline(canvas, text, tp.width, tp.height);
    }

    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  void _paintTextOutline(Canvas canvas, String text, double w, double h) {
    final TextPainter tpOutline = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0A2E0A),
          fontFamily: 'Georgia',
          shadows: [Shadow(color: const Color(0xFF0A2E0A), blurRadius: 4)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tpOutline.paint(canvas, Offset(-w / 2, -h / 2));
  }

  void _drawPlainLine(
    Canvas canvas,
    Paint paint,
    Offset a,
    Offset b,
    double radius,
  ) {
    final double angle = (b - a).direction;
    final Offset start =
        a + Offset(radius * math.cos(angle), radius * math.sin(angle));
    final Offset end =
        b - Offset(radius * math.cos(angle), radius * math.sin(angle));
    canvas.drawLine(start, end, paint);
  }

  void _drawArrowLine(
    Canvas canvas,
    Paint paint,
    Offset start,
    Offset end,
    double radius,
  ) {
    final double angle = (end - start).direction;
    final Offset adjStart =
        start + Offset(radius * math.cos(angle), radius * math.sin(angle));
    final Offset adjEnd =
        end - Offset(radius * math.cos(angle), radius * math.sin(angle));
    canvas.drawLine(adjStart, adjEnd, paint);
    _drawArrowHead(canvas, paint, adjEnd, angle);
  }

  void _drawArrowHead(Canvas canvas, Paint paint, Offset tip, double angle) {
    const double arrowSize = 10.0;
    final Path path =
        Path()
          ..moveTo(tip.dx, tip.dy)
          ..lineTo(
            tip.dx - arrowSize * math.cos(angle - 0.45),
            tip.dy - arrowSize * math.sin(angle - 0.45),
          )
          ..lineTo(
            tip.dx - arrowSize * math.cos(angle + 0.45),
            tip.dy - arrowSize * math.sin(angle + 0.45),
          )
          ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = paint.color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

enum LabelSide { left, right, top, bottom }
