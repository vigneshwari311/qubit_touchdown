import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final String gate;
  final VoidCallback onTap;
  final bool isEnabled;
  final double height;

  const ActionCard({
    super.key,
    required this.gate,
    required this.onTap,
    required this.height,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    Color mainColor;
    if (gate == 'H') {
      mainColor = const Color(0xFF8B0000);
    } else if (gate == 'X' || gate == 'Y') {
      mainColor = const Color(0xFFD35400);
    } else if (gate == 'S' || gate == 'Z') {
      mainColor = const Color(0xFF006064);
    } else if (gate == '√X') {
      mainColor = const Color(0xFF5D4037);
    } else {
      mainColor = Colors.blueGrey.shade800;
    }

    final double width = height * 0.72;
    final double cornerFontSize = height * 0.12;
    final double centerFontSize = height * 0.34;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [mainColor.withAlpha(204), mainColor],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white24, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(77),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 5,
                left: 5,
                child: Text(
                  gate,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: cornerFontSize,
                  ),
                ),
              ),
              Center(
                child: Text(
                  gate,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: centerFontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Transform.rotate(
                  angle: 3.14159,
                  child: Text(
                    gate,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: cornerFontSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
