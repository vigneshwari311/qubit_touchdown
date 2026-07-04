import 'dart:ui';
import 'package:flutter/material.dart';

enum LabelSide { left, right, top, bottom, center }

class QubitNodeConnectorModel {
  final Offset from;
  final Offset to;
  final String label;
  final bool isArrow;
  final LabelSide labelSide;
  final double labelOffset;

  // Controls the dual-label splitting for long center lanes
  final bool splitLabels;
  final double startLerp;
  final double endLerp;

  QubitNodeConnectorModel({
    required this.from,
    required this.to,
    required this.label,
    this.isArrow = false,
    this.labelSide = LabelSide.center,
    this.labelOffset = 0.0,
    this.splitLabels = false,
    this.startLerp = 0.22,
    this.endLerp = 0.78,
  });
}
