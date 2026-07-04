import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:qubit_touchdown/api/game.dart';
import 'package:qubit_touchdown/components/player_toggle_btn.dart';
import 'package:qubit_touchdown/components/quantum_circuit_display.dart';
import 'package:qubit_touchdown/provider/game.dart';
import 'package:qubit_touchdown/screens/home_screen.dart';

class TouchdownScreen extends StatefulWidget {
  final int currentPlayer; // treated as the winner / default selected player
  final Map<String, dynamic>? preloadedCircuitData;
  final Map<String, dynamic>? preloadedBlochData;

  const TouchdownScreen({
    super.key,
    required this.currentPlayer,
    this.preloadedCircuitData,
    this.preloadedBlochData,
  });

  @override
  State<TouchdownScreen> createState() => _TouchdownScreenState();
}

class _TouchdownScreenState extends State<TouchdownScreen> {
  // Cache per-player data so switching players doesn't refetch every time.
  final Map<int, _PlayerVisuals> _cache = {};

  late int _selectedPlayer;
  bool _loading = true;
  String? _error;
  bool _coinTossLottie = false;

  @override
  void initState() {
    super.initState();
    _selectedPlayer = widget.currentPlayer;

    if (widget.preloadedCircuitData != null &&
        widget.preloadedBlochData != null) {
      _cache[_selectedPlayer] = _PlayerVisuals(
        idealImageB64: widget.preloadedCircuitData!['ideal_image'],
        transpiledImageB64: widget.preloadedCircuitData!['transpiled_image'],
        blochGifB64: widget.preloadedBlochData!['gif'],
      );
      _loading = false;
    }

    _loadVisuals(_selectedPlayer);
  }

  Future<void> _loadVisuals(int player) async {
    if (_cache.containsKey(player)) {
      setState(() {
        _loading = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final game = context.read<GameProvider>();
    final gates = player == 1 ? game.p1History : game.p2History;
    final playerId = player == 1 ? 'player1' : 'player2';

    try {
      final circuitData = await GameApi.generateCircuit(
        playerId: playerId,
        gates: gates,
      );
      final blochData = await GameApi.generateBlochAnimation(
        playerId: playerId,
        gates: gates,
      );

      _cache[player] = _PlayerVisuals(
        idealImageB64: circuitData['ideal_image'],
        transpiledImageB64: circuitData['transpiled_image'],
        blochGifB64: blochData['gif'],
      );

      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _selectPlayer(int player) {
    if (_selectedPlayer == player) return;
    setState(() {
      _selectedPlayer = player;
    });
    _loadVisuals(player);
  }

  void _handleCoinToss() async {
    setState(() {
      _coinTossLottie = true;
    });
    // let the overlay mount first, then fade it in
    await Future.delayed(const Duration(milliseconds: 20));

    final navigator = Navigator.of(context);
    final gameProvider = context.read<GameProvider>();
    final int randomActiveNode = Random().nextInt(2);

    await Future.delayed(const Duration(milliseconds: 2500));

    gameProvider.performMeasurementAndToss(randomActiveNode);

    if (!mounted) return;

    // fade the overlay out first...
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    // ...then navigate, with a fade transition instead of the default slide
    navigator.pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder:
            (_, __, ___) => const HomeScreen(), // your actual home widget
        transitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final visuals = _cache[_selectedPlayer];

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Icon(
                      Icons.sports_football,
                      size: 80,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "TOUCHDOWN!",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color:
                            _selectedPlayer == 1
                                ? Colors.blueAccent
                                : const Color(0xFFE91E63),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      color: Colors.black,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "PLAYER $_selectedPlayer",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),

                          _loading
                              ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.amber,
                                  ),
                                ),
                              )
                              : _error != null
                              ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Text(
                                  "Couldn't load visualization",
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              )
                              : visuals?.blochGifB64 != null
                              ? SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: Image.memory(
                                  base64Decode(visuals!.blochGifB64!),
                                ),
                              )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "VIEW YOUR CIRCUIT",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Player 1 / Player 2 toggle row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: PlayerToggleButton(
                              label: "PLAYER 1",
                              isSelected: _selectedPlayer == 1,
                              color: Colors.blueAccent,
                              onTap: () => _selectPlayer(1),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            child: PlayerToggleButton(
                              label: "PLAYER 2",
                              isSelected: _selectedPlayer == 2,
                              color: const Color(0xFFE91E63),
                              onTap: () => _selectPlayer(2),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (_loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: CircularProgressIndicator(color: Colors.amber),
                      )
                    else if (_error != null)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Couldn't load circuit",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      )
                    else if (visuals?.idealImageB64 != null)
                      Column(
                        children: [
                          QuantumCircuitDisplay(
                            label: "Ideal circuit",
                            imageB64: visuals!.idealImageB64,
                          ),

                          const SizedBox(height: 16),

                          // Arrow + label between ideal and transpiled circuits
                          Icon(
                            Icons.arrow_downward_rounded,
                            color: Colors.amber,
                            size: 32,
                          ),

                          const SizedBox(height: 16),

                          QuantumCircuitDisplay(
                            label: "Transpiled circuit",
                            imageB64: visuals.transpiledImageB64,
                          ),
                        ],
                      ),

                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 30,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                    minWidth: 400,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: _coinTossLottie ? null : _handleCoinToss,

                      child: const Text(
                        "TOSS THE COIN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Full-screen solid black canvas overlay presenting the Lottie coin flip
            if (_coinTossLottie)
              Positioned.fill(
                child: AbsorbPointer(
                  absorbing: true, // Blocks accidental tapping behind the view
                  child: Container(
                    color:
                        Colors
                            .black, // Removing opacity makes this completely solid black
                    child: Center(
                      child: Lottie.asset(
                        'assets/coin_flip.json',
                        width: 500,
                        height: 500,
                        repeat: false,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlayerVisuals {
  final String? idealImageB64;
  final String? transpiledImageB64;
  final String? blochGifB64;

  _PlayerVisuals({
    this.idealImageB64,
    this.transpiledImageB64,
    this.blochGifB64,
  });
}
