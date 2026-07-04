import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qubit_touchdown/provider/game.dart';

enum PlayerIndex { player1, player2 }

class PlayerScoreCard extends StatelessWidget {
  final PlayerIndex playerIndex;

  const PlayerScoreCard({super.key, required this.playerIndex});

  @override
  Widget build(BuildContext context) {
    // 1. Listen cleanly to changes in your game state provider
    final gameProvider = context.watch<GameProvider>();

    // 2. Determine configuration based on the target player parameter
    final isPlayer1 = playerIndex == PlayerIndex.player1;

    final String label = isPlayer1 ? "PLAYER 1" : "PLAYER 2";
    final int score = isPlayer1 ? gameProvider.p1Score : gameProvider.p2Score;

    // Smooth matching theme colors (Blue vs. Neon Crimson/Pink)
    final Color baseColor =
        isPlayer1 ? const Color(0xFF2196F3) : const Color(0xFFE91E63);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Player Identifier Label
        Text(
          label,
          style: TextStyle(
            color: baseColor.withAlpha(220),
            fontWeight: FontWeight.bold,
            fontSize: 11,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        // Clean, High-Contrast Score Container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: baseColor.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "$score",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace', // Prevents numbers layout shifting
              shadows: [Shadow(color: baseColor.withAlpha(150), blurRadius: 8)],
            ),
          ),
        ),
      ],
    );
  }
}
