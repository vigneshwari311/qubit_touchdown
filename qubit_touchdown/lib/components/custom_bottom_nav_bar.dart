import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qubit_touchdown/components/action_cards.dart';
import 'package:qubit_touchdown/provider/game.dart';
import 'package:qubit_touchdown/screens/info_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double height = constraints.maxHeight;
        final double cardHeight = height * 0.55;
        return Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InfoScreen()),
                      ),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 1.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "INFO",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Divider(),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
                child: Text(
                  game.currentPlayer == 1 ? "PLAYER 1" : "PLAYER 2",
                  style: TextStyle(
                    color:
                        game.currentPlayer == 1
                            ? const Color(0xFF2196F3)
                            : const Color(0xFFE91E63),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  game.currentHand.map((gateSymbol) {
                    return ActionCard(
                      height: cardHeight,
                      gate: gateSymbol,
                      onTap: () => game.nodeTransition(gateSymbol),
                    );
                  }).toList(),
            ),
          ],
        );
      },
    );
  }
}
