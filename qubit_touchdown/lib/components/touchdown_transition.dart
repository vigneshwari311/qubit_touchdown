import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:qubit_touchdown/api/game.dart';
import 'package:qubit_touchdown/provider/game.dart';
import 'package:qubit_touchdown/screens/touchdown_screen.dart';

class TouchdownTransition extends StatefulWidget {
  final int currentPlayer;

  const TouchdownTransition({super.key, required this.currentPlayer});

  @override
  State<TouchdownTransition> createState() => _TouchdownTransitionState();
}

class _TouchdownTransitionState extends State<TouchdownTransition> {
  Map<String, dynamic>? _circuitData;
  Map<String, dynamic>? _blochData;
  bool _animationDone = false;
  bool _dataReady = false;

  @override
  void initState() {
    super.initState();
    _prefetch();
  }

  Future<void> _prefetch() async {
    final game = context.read<GameProvider>();
    final player = widget.currentPlayer;
    final gates = player == 1 ? game.p1History : game.p2History;
    final playerId = player == 1 ? 'player1' : 'player2';

    try {
      final results = await Future.wait([
        GameApi.generateCircuit(playerId: playerId, gates: gates),
        GameApi.generateBlochAnimation(playerId: playerId, gates: gates),
      ]);
      if (!mounted) return;
      setState(() {
        _circuitData = results[0];
        _blochData = results[1];
        _dataReady = true;
      });
    } catch (_) {
      // Even on failure, let it proceed — TouchdownScreen has its own error UI
      if (!mounted) return;
      setState(() => _dataReady = true);
    }
    _touchDownNavigate();
  }

  void _onAnimationFinished() {
    _animationDone = true;
    _touchDownNavigate();
  }

  void _touchDownNavigate() {
    // Only move on once BOTH the animation has played AND data fetch is done.
    if (_animationDone && _dataReady && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (_) => TouchdownScreen(
                currentPlayer: widget.currentPlayer,
                preloadedCircuitData: _circuitData,
                preloadedBlochData: _blochData,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: Lottie.asset(
          'assets/football_goal.json',

          repeat: false,
          onLoaded: (composition) {
            // Fallback safety: if onFinished isn't reliable on some platforms,
            // schedule based on the animation's own duration.
            Future.delayed(composition.duration, _onAnimationFinished);
          },
        ),
      ),
    );
  }
}
