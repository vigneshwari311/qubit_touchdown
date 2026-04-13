import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final String gate;
  final VoidCallback onTap;
  final bool isEnabled;

  const ActionCard({
    super.key,
    required this.gate,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    Color mainColor;
    if (gate == 'H')
      mainColor = const Color(0xFF8B0000); 
    else if (gate == 'X' || gate == 'Y')
      mainColor = const Color(0xFFD35400);
    else if (gate == 'S' || gate == 'Z')
      mainColor = const Color(0xFF006064); 
    else if (gate == '√X')
      mainColor = const Color(0xFF5D4037); 
    else
      mainColor = Colors.blueGrey.shade800; 

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Container(
          width: 90,
          height: 130,
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
              // Top Gate Label
              Positioned(
                top: 5,
                left: 5,
                child: Text(
                  gate,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              // Main Central Gate Label
              Center(
                child: Text(
                  gate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                  ),
                ),
              ),
              // Bottom Rotated Gate Label (Like a playing card)
              Positioned(
                bottom: 5,
                right: 5,
                child: Transform.rotate(
                  angle: 3.14159, // 180 degrees
                  child: Text(
                    gate,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
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
