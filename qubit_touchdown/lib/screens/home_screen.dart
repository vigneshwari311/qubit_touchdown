import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qubit_touchdown/components/custom_app_bar.dart';
import 'package:qubit_touchdown/components/custom_bottom_nav_bar.dart';
import 'package:qubit_touchdown/components/game_over_dialog.dart';
import 'package:qubit_touchdown/components/player_score_card.dart';
import 'package:qubit_touchdown/components/quantum_board/quantum_board.dart';
import 'package:qubit_touchdown/components/touchdown_transition.dart';
import 'package:qubit_touchdown/components/turn_handoff_overlay.dart';
import 'package:qubit_touchdown/provider/game.dart';
import 'package:qubit_touchdown/screens/measurement_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final screenHeight = MediaQuery.of(context).size.height;

    if (game.gameStatus == GameStatus.touchdown) {
      return TouchdownTransition(currentPlayer: game.lastScorer);
    }
    if (game.gameStatus == GameStatus.measuring ||
        game.gameStatus == GameStatus.measuringResult) {
      return const MeasurementScreen();
    }
    if (game.gameStatus == GameStatus.turnHandoff) {
      return const TurnHandoffOverlay();
    }

    if (game.gameStatus == GameStatus.gameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => GameOverDialog(
                p1Score: game.p1Score,
                p2Score: game.p2Score,
                onPlayAgain: () => game.initializeGame(),
              ),
        );
      });
    }

    return Scaffold(
      appBar: CustomAppBar(),
      // backgroundColor: ,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const PlayerScoreCard(playerIndex: PlayerIndex.player1),
              //Spacer(),

              //Centered Divider Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "VS",
                  style: TextStyle(
                    color: Colors.white.withAlpha(50),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              //Spacer(),
              // Renders the clean Pink container tracking Player 2's score
              const PlayerScoreCard(playerIndex: PlayerIndex.player2),
            ],
          ),

          Expanded(
            child: Center(child: QuantumBoard(currentPos: game.currentPos)),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height:
            screenHeight *
            0.26, // Expanded past 120 to provide comfortable layout margins
        child: const CustomBottomNavBar(),
      ),
    );
  }
}
