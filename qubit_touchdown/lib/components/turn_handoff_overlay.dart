import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qubit_touchdown/provider/game.dart';

class TurnHandoffOverlay extends StatelessWidget {
  const TurnHandoffOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    // Matches your standard integer player markers
    final isP1 = game.currentPlayer == 1;
    final themeColor = isP1 ? const Color(0xFF2196F3) : const Color(0xFFE91E63);

    return Scaffold(
      backgroundColor: const Color(
        0xFF0F111A,
      ), // Matches your deep game theme background
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: BoxDecoration(
                color: const Color(0xFF161618),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: themeColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withAlpha(50),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Pass device top banner icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: themeColor.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons
                          .reply_all_rounded, // Visual pass-phone indicator arrow
                      size: 36,
                      color: themeColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "PASS THE DEVICE",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isP1 ? "PLAYER 1'S TURN" : "PLAYER 2'S TURN",
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Non-interactive decorative timer bar signaling processing time
                  SizedBox(
                    width: 140,
                    child: LinearProgressIndicator(
                      color: themeColor,
                      backgroundColor: Colors.white10,
                      minHeight: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "HANDING OVER...",
                    style: TextStyle(
                      color: themeColor.withAlpha(180),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
