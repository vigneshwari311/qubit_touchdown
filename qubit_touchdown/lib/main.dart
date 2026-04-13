import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:qubit_touchdown/components/action_cards.dart';
import 'package:qubit_touchdown/components/quantum_board.dart';
import 'package:qubit_touchdown/provider/game_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameProvider()..setupGame(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Qubit TouchDown",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Qubit TouchDown'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _buildScoreColumn(String label, int score, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          "$score",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCircuitDisplay(String? base64Str) {
    if (base64Str == null) {
      return const SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Image.memory(
        base64Decode(base64Str.replaceAll(RegExp(r'\s+'), '')),
        height: 110,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _backendButton(
    BuildContext context,
    GameProvider game,
    String label,
    String? key,
    Color color,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withAlpha(51),
        side: BorderSide(color: color, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        minimumSize: const Size(60, 30),
      ),
      onPressed: () => game.updateCircuitForBackend(key),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.style, color: Colors.white60, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      "${game.deckCount}",
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white60,
                    size: 24,
                  ),
                  onPressed: () => game.setupGame(),
                  tooltip: "Reset Game",
                ),
              ],
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "QUBIT TOUCHDOWN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildScoreColumn("P1", game.p1Score, Colors.blue),
                        const SizedBox(width: 40),
                        const Text(
                          "VS",
                          style: TextStyle(color: Colors.white24, fontSize: 16),
                        ),
                        const SizedBox(width: 40),
                        _buildScoreColumn("P2", game.p2Score, Colors.red),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Transform.scale(
                      scale: 0.85,
                      child: QuantumBoard(currentPos: game.currentPos),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "PLAYER ${game.currentPlayer}'S TURN",
                      style: TextStyle(
                        color:
                            game.currentPlayer == 1 ? Colors.blue : Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      children:
                          game.currentHand.map((gateSymbol) {
                            return SizedBox(
                              width: 55,
                              height: 80,
                              child: ActionCard(
                                gate: gateSymbol,
                                onTap: () => game.playCard(gateSymbol),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (game.status != GameStatus.playing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(242),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (game.status == GameStatus.touchdown) ...[
                        const Text(
                          "TOUCHDOWN!",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            const Text(
                              "IDEAL LOGIC",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            _buildCircuitDisplay(game.idealCircuit),
                            if (game.transpiledCircuit != null) ...[
                              const SizedBox(height: 10),
                              const Icon(
                                Icons.arrow_downward,
                                color: Colors.white24,
                                size: 16,
                              ),
                              const Text(
                                "TRANSPILED CIRCUIT",
                                style: TextStyle(
                                  color: Colors.purpleAccent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              _buildCircuitDisplay(game.transpiledCircuit),
                            ],
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${game.lastScorerName} Scored!",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "VIEW ON FAKE PROVIDER - SIMULATOR:",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _backendButton(
                              context,
                              game,
                              "Reset",
                              null,
                              Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            _backendButton(
                              context,
                              game,
                              "IBM Osaka",
                              "osaka",
                              Colors.purple,
                            ),
                            const SizedBox(width: 8),
                            _backendButton(
                              context,
                              game,
                              "IBM Kyoto",
                              "kyoto",
                              Colors.blue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                          ),
                          onPressed: () => game.performKickoffToss(),
                          child: const Text(
                            "TOSS FOR KICKOFF",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                      if (game.status == GameStatus.tossing) ...[
                        if (game.currentPos == '+' ||
                            game.currentPos == '−') ...[
                          Lottie.asset(
                            'assets/coin_flip.json',
                            width: 200,
                            height: 200,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "KICKING OFF...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              letterSpacing: 2,
                            ),
                          ),
                        ] else ...[
                          const Text(
                            "MEASURING...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 6,
                            ),
                          ),
                          const SizedBox(height: 50),
                          Text(
                            "|${game.tossResult}⟩",
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 130,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ],
                      if (game.status == GameStatus.tossResult) ...[
                        Text(
                          (game.currentPos == '0' || game.currentPos == '1')
                              ? "KICKOFF RESULT:"
                              : "MEASUREMENT COLLAPSED:",
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 18,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "|${game.tossResult}⟩",
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            shadows: [
                              Shadow(color: Colors.greenAccent, blurRadius: 40),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
