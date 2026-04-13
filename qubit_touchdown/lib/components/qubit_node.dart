import 'package:flutter/material.dart';

class QubitNode extends StatelessWidget {
  final String label;
  final bool isActive;
  final double radius; 

  const QubitNode({
    super.key,
    required this.label,
    required this.isActive,
    this.radius = 30,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow:
            isActive
                ? [
                  BoxShadow(
                    color: Colors.orange.withAlpha(1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ]
                : [],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: isActive ? Colors.orange : const Color(0xFFf0c020),
        child: CircleAvatar(
          radius: radius - 3,
          backgroundColor:
              isActive ? Colors.orangeAccent : const Color(0xFFf5d040),
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xFF1a1a0a),
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
              fontSize: label.length > 1 ? radius * 0.6 : radius * 0.75,
            ),
          ),
        ),
      ),
    );
  }
}
