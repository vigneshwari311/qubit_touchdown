import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qubit_touchdown/provider/game.dart';

class MeasurementScreen extends StatelessWidget {
  const MeasurementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child:
            game.gameStatus == GameStatus.measuring
                ? (game.wasSuperposition
                    ? const _SuperpositionMeasuring()
                    : const _DefiniteMeasuring())
                : _MeasurementResult(
                  result: game.measurementResult,
                  wasSuperposition: game.wasSuperposition,
                ),
      ),
    );
  }
}


class _SuperpositionMeasuring extends StatefulWidget {
  const _SuperpositionMeasuring();

  @override
  State<_SuperpositionMeasuring> createState() =>
      _SuperpositionMeasuringState();
}

class _SuperpositionMeasuringState extends State<_SuperpositionMeasuring> {
  late final Timer _timer;
  String _flickerValue = '0';
  final _rand = Random();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      setState(() => _flickerValue = _rand.nextBool() ? '0' : '1');
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "MEASURING...",
          style: TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 6),
        ),
        const SizedBox(height: 50),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 12),
          transitionBuilder:
              (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
          child: Text(
            "|$_flickerValue⟩",
            key: ValueKey(_flickerValue),
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 130,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }
}


class _DefiniteMeasuring extends StatelessWidget {
  const _DefiniteMeasuring();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "NODE ALREADY DEFINITE",
          style: TextStyle(
            color: Colors.white54,
            fontSize: 18,
            letterSpacing: 3,
          ),
        ),
        SizedBox(height: 24),
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            color: Colors.white24,
            strokeWidth: 3,
          ),
        ),
      ],
    );
  }
}

class _MeasurementResult extends StatelessWidget {
  final String result;
  final bool wasSuperposition;

  const _MeasurementResult({
    required this.result,
    required this.wasSuperposition,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          wasSuperposition ? "MEASUREMENT COLLAPSED:" : "RESULT:",
          style: const TextStyle(
            color: Colors.greenAccent,
            fontSize: 18,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 30),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.7, end: 1.0),
          duration: const Duration(milliseconds: 350),
          curve: Curves.elasticOut,
          builder:
              (context, scale, child) =>
                  Transform.scale(scale: scale, child: child),
          child: Text(
            "|$result⟩",
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 100,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              shadows: [Shadow(color: Colors.greenAccent, blurRadius: 40)],
            ),
          ),
        ),
      ],
    );
  }
}
