import 'package:flutter/material.dart';
import 'package:qubit_touchdown/components/board_lines_painter.dart';
import 'package:qubit_touchdown/components/qubit_node.dart';

class QuantumBoard extends StatelessWidget {
  final String currentPos;

  const QuantumBoard({super.key, required this.currentPos});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
     
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double w = constraints.maxWidth;
          final double h = constraints.maxHeight;
          const double nodeRadius = 30;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Yard-line decoration
              Positioned.fill(child: CustomPaint(painter: _YardLinesPainter())),
              // All arrows + labels
              Positioned.fill(child: CustomPaint(painter: BoardLinesPainter())),
              // + (top)
              _node(w * 0.50, h * 0.12, '+', nodeRadius),
              // 0 (mid-left)
              _node(w * 0.24, h * 0.37, '0', nodeRadius),
              // -i (mid-right)
              _node(w * 0.76, h * 0.37, '−i', nodeRadius),
              // i (bot-left)
              _node(w * 0.24, h * 0.63, 'i', nodeRadius),
              // 1 (bot-right)
              _node(w * 0.76, h * 0.63, '1', nodeRadius),
              // - (bottom)
              _node(w * 0.50, h * 0.88, '−', nodeRadius),
            ],
          );
        },
      ),
    );
  }

  Widget _node(double cx, double cy, String label, double r) {
    return Positioned(
      left: cx - r,
      top: cy - r,
      child: QubitNode(label: label, isActive: currentPos == label, radius: r),
    );
  }
}

//  Subtle yard lines
class _YardLinesPainter extends CustomPainter {
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











