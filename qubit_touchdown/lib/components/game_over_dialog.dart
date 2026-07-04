import 'package:flutter/material.dart';

class GameOverDialog extends StatelessWidget {
  final int p1Score;
  final int p2Score;
  final VoidCallback onPlayAgain;

  const GameOverDialog({
    super.key,
    required this.p1Score,
    required this.p2Score,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    String winnerText = "";
    Color winnerColor = Colors.white;

    if (p1Score > p2Score) {
      winnerText = "PLAYER 1 WINS!";
      winnerColor = Colors.blueAccent;
    } else if (p2Score > p1Score) {
      winnerText = "PLAYER 2 WINS!";
      winnerColor = const Color(0xFFE91E63);
    } else {
      winnerText = "IT'S A TIE!";
      winnerColor = Colors.amber;
    }

    return AlertDialog(
      backgroundColor: const Color(
        0xFF1E1E1E,
      ), // Match your dark app background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events, size: 60, color: Colors.amber),
          SizedBox(height: 10),
          Text(
            "GAME OVER",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            winnerText,
            style: TextStyle(
              color: winnerColor,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "Final Score: $p1Score - $p2Score",
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the custom dialog
              onPlayAgain(); // Reset provider logic
            },
            icon: const Icon(Icons.refresh),
            label: const Text(
              "PLAY AGAIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
