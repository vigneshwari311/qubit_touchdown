import 'package:flutter/material.dart';
import 'package:qubit_touchdown/components/quantum_board/qubit_node.dart';
import 'package:qubit_touchdown/components/quantum_board/qubit_node_connector_painter.dart';
import 'package:qubit_touchdown/models/qubit_node_connector_model.dart';

class QuantumBoard extends StatelessWidget {
  final String currentPos;
  final double radius;

  static const posPlus = Offset(0.5, 0.05);
  static const posZero = Offset(0.24, 0.30);
  static const posMinusI = Offset(0.76, 0.30);
  static const posI = Offset(0.24, 0.68);
  static const posOne = Offset(0.76, 0.68);
  static const posMinus = Offset(0.5, 0.93);

  static final List<QubitNodeConnectorModel> _staticConnections = [
    // Top Diamond Boundaries (Pushed outwards)
    QubitNodeConnectorModel(
      from: posZero,
      to: posPlus,
      label: "H",
      isArrow: false,
      labelSide: LabelSide.left,
      labelOffset: 14,
    ),
    QubitNodeConnectorModel(
      from: posMinusI,
      to: posPlus,
      label: "S",
      isArrow: true,
      labelSide: LabelSide.right,
      labelOffset: 16,
    ),

    // =========================================================================
    // FIX: Bottom Diamond Boundaries - Swapped sides to force text OUTSIDE
    // =========================================================================
    QubitNodeConnectorModel(
      from: posI,
      to: posMinus,
      label: "S",
      isArrow: true,
      labelSide: LabelSide.right,
      labelOffset: 16,
    ), // Changed from left to right
    QubitNodeConnectorModel(
      from: posOne,
      to: posMinus,
      label: "H",
      isArrow: false,
      labelSide: LabelSide.left,
      labelOffset: 16,
    ), // Changed from right to left
    // Crossing lanes configured with double-split text labels and masking blocks
    QubitNodeConnectorModel(
      from: posZero,
      to: posOne,
      label: "X, Y",
      labelSide: LabelSide.center,
      splitLabels: true,
      startLerp: 0.24,
      endLerp: 0.76,
    ),
    QubitNodeConnectorModel(
      from: posMinusI,
      to: posI,
      label: "X, Z, H",
      labelSide: LabelSide.center,
      splitLabels: true,
      startLerp: 0.28,
      endLerp: 0.72,
    ),

    // Outer Grid Crossings
    QubitNodeConnectorModel(
      from: posZero,
      to: posMinusI,
      label: "√X",
      isArrow: true,
      labelSide: LabelSide.top,
      labelOffset: 16,
    ),
    QubitNodeConnectorModel(
      from: posOne,
      to: posI,
      label: "√X",
      isArrow: true,
      labelSide: LabelSide.top,
      labelOffset: 16,
    ),
    QubitNodeConnectorModel(
      from: posI,
      to: posZero,
      label: "√X",
      isArrow: true,
      labelSide: LabelSide.left,
      labelOffset: 16,
    ),
    QubitNodeConnectorModel(
      from: posMinusI,
      to: posOne,
      label: "√X",
      isArrow: true,
      labelSide: LabelSide.left,
      labelOffset: 16,
    ),
  ];

  const QuantumBoard({super.key, required this.currentPos, this.radius = 26.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(child: CustomPaint(painter: YardLinesPainter())),

            Positioned.fill(
              child: CustomPaint(
                painter: QubitNodeConnectorPainter(
                  connections: _staticConnections,
                  nodeRadius: radius,
                ),
              ),
            ),

            _buildNode(constraints, posPlus, '+', radius),
            _buildNode(constraints, posZero, '0', radius),
            _buildNode(constraints, posMinusI, '−i', radius),
            _buildNode(constraints, posI, 'i', radius),
            _buildNode(constraints, posOne, '1', radius),
            _buildNode(constraints, posMinus, '−', radius),
          ],
        );
      },
    );
  }

  Widget _buildNode(
    BoxConstraints constraints,
    Offset fractionalOffset,
    String label,
    double r,
  ) {
    final double x = fractionalOffset.dx * constraints.maxWidth;
    final double y = fractionalOffset.dy * constraints.maxHeight;

    return Positioned(
      left: x - r,
      top: y - r,
      child: QubitNode(label: label, isActive: currentPos == label, radius: r),
    );
  }
}
