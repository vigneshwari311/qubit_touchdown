import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qubit_touchdown/provider/game.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();

    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(bottom: BorderSide(color: Colors.white70, width: 0.5)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Deck count pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1D26),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF2A2D35),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.style_outlined,
                      size: 18,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${game.deckCount}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // Title - centered
              Expanded(
                child: Center(
                  child: Text(
                    'QUBIT TOUCHDOWN',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),

              // Refresh button
              GestureDetector(
                onTap: () => game.initializeGame(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1D26),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF2A2D35),
                      width: 0.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    size: 18,
                    color: Colors.white70,
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
