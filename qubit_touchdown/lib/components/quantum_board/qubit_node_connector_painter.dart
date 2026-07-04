import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:qubit_touchdown/models/qubit_node_connector_model.dart';

class YardLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.06)
          ..strokeWidth = 1;
    const int lines = 5;
    for (int i = 1; i < lines; i++) {
      final double y = size.height * i / lines;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
}

class QubitNodeConnectorPainter extends CustomPainter {
  final List<QubitNodeConnectorModel> connections;
  final double nodeRadius;

  // Visible gap between the arrow tip and the node's edge.
  // Set to 0 for the tip to touch the edge exactly.
  static const double arrowGap = 0;
  static const double arrowSize = 18.0;

  QubitNodeConnectorPainter({
    required this.connections,
    required this.nodeRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint linePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.9)
          ..strokeWidth = 6
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final Paint arrowPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.9)
          ..style = PaintingStyle.fill;

    for (var conn in connections) {
      final Offset p1 = Offset(conn.from.dx * w, conn.from.dy * h);
      final Offset p2 = Offset(conn.to.dx * w, conn.to.dy * h);

      final Offset dir = p2 - p1;
      final double distance = dir.distance;
      if (distance == 0) continue;

      final double angle = dir.direction;
      final Offset unit = Offset(math.cos(angle), math.sin(angle));

      // Trim start normally off node 1's edge
      final Offset lineStart = p1 + unit * nodeRadius;

      // Arrow tip sits exactly on node 2's edge (+ optional gap)
      final Offset tip = p2 - unit * (nodeRadius + arrowGap);

      // The line stops at the BACK of the arrowhead (not the tip itself),
      // so the round stroke cap never bleeds past the triangle into the node.
      final Offset lineEnd = conn.isArrow ? tip - unit * arrowSize : tip;

      canvas.drawLine(lineStart, lineEnd, linePaint);

      if (conn.isArrow) {
        _drawArrowHead(canvas, arrowPaint, tip, angle);
      }

      // Draw Slanted Labels
      if (conn.label.isNotEmpty) {
        if (conn.splitLabels) {
          // Render dual labels separated cleanly via lerp percentages
          final Offset position1 = Offset.lerp(p1, p2, conn.startLerp)!;
          _drawLabel(canvas, conn, position1, angle, dir, distance);

          final Offset position2 = Offset.lerp(p1, p2, conn.endLerp)!;
          _drawLabel(canvas, conn, position2, angle, dir, distance);
        } else {
          // Standard single label
          final Offset standardMid = Offset(
            (lineStart.dx + lineEnd.dx) / 2,
            (lineStart.dy + lineEnd.dy) / 2,
          );
          _drawLabel(canvas, conn, standardMid, angle, dir, distance);
        }
      }
    }
  }

  // Draws just the arrowhead triangle at [tip], pointing along [angle].
  // Lifted from the old BoardLinesPainter._drawArrowHead ΓÇö this is the part
  // that was already rendering correctly tip-on-edge.
  void _drawArrowHead(Canvas canvas, Paint paint, Offset tip, double angle) {
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

  void _drawLabel(
    Canvas canvas,
    QubitNodeConnectorModel conn,
    Offset computedPoint,
    double angle,
    Offset dir,
    double distance,
  ) {
    final Offset perp = Offset(-dir.dy / distance, dir.dx / distance);
    final double sign =
        (conn.labelSide == LabelSide.right ||
                conn.labelSide == LabelSide.bottom)
            ? 1.0
            : -1.0;

    // Shift calculations
    final Offset labelPos =
        (conn.labelSide == LabelSide.center)
            ? computedPoint
            : computedPoint + (perp * (conn.labelOffset * sign));

    final TextPainter tp = TextPainter(
      text: TextSpan(
        // Padding spaces help mask out lines cleanly
        text: " ${conn.label} ",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF5C518),
          fontFamily: 'Georgia',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(labelPos.dx, labelPos.dy);

    double rotationAngle = angle;
    if (rotationAngle > math.pi / 2 || rotationAngle < -math.pi / 2) {
      rotationAngle += math.pi;
    }
    canvas.rotate(rotationAngle);

    // Dynamic background mask box layout
    final Rect backgroundBox = Rect.fromCenter(
      center: Offset.zero,
      width: tp.width,
      height: tp.height * 0.9,
    );
    canvas.drawRect(backgroundBox, Paint()..color = const Color(0xFF0d1117));

    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant QubitNodeConnectorPainter oldDelegate) => false;
}
