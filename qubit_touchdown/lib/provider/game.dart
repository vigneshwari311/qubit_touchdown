import 'package:flutter/material.dart';
import 'package:qubit_touchdown/quantum_logic.dart';
import 'dart:math';

enum GameStatus { playing, touchdown, measuring, measuringResult,turnHandoff, gameOver }


class GameProvider with ChangeNotifier {
  List<String> _deck = [];
  List<String> _p1Hand = [];
  List<String> _p2Hand = [];
  int _p1Score = 0;
  int _p2Score = 0;
  int _currentPlayer = 1;
  int _lastScorer = 1;
  String _currentPos = '0';
  GameStatus _gameStatus = GameStatus.playing;
  final List<String> _p1History = [];
  final List<String> _p2History = [];
  String _measurementResult = '0';
  bool _wasSuperposition = false;
  bool _isMeasuring = false;

  List<String> get p1Hand => _p1Hand;
  List<String> get p2Hand => _p2Hand;
  List<String> get p1History => List.unmodifiable(_p1History);
  List<String> get p2History => List.unmodifiable(_p2History);
  int get p1Score => _p1Score;
  int get p2Score => _p2Score;
  int get currentPlayer => _currentPlayer;
  int get lastScorer => _lastScorer;
  String get currentPos => _currentPos;
  List<String> get currentHand => _currentPlayer == 1 ? _p1Hand : _p2Hand;
  GameStatus get gameStatus => _gameStatus;
  String get measurementResult => _measurementResult;
  bool get wasSuperposition => _wasSuperposition;
  bool get isMeasuring => _isMeasuring;
  int get deckCount => _deck.length;

  void initializeGame() {
    _p1Hand.clear();
    _p2Hand.clear();
    _p1History.clear();
    _p2History.clear();
    _p1Score = 0;
    _p2Score = 0;
    _currentPlayer = 1;
    _lastScorer = 1;
    _currentPos = '0';
    _gameStatus = GameStatus.playing;
    _measurementResult = '0';
    _wasSuperposition = false;

    _deck = [
      ...List.filled(7, 'H'),
      ...List.filled(7, 'S'),
      ...List.filled(7, 'Z'),
      ...List.filled(4, 'X'),
      ...List.filled(9, 'Y'),
      ...List.filled(3, 'I'),
      ...List.filled(3, 'M'),
      ...List.filled(12, '√X'),
    ];

    _deck.shuffle();

    for (int i = 0; i < 4; i++) {
      _p1Hand.add(_deck.removeLast());
      _p2Hand.add(_deck.removeLast());
    }

    notifyListeners();
  }

  Future<void> _handleMeasurement() async {
    final bool isDefinite = _currentPos == '0' || _currentPos == '1';
    _wasSuperposition = !isDefinite;

    _gameStatus = GameStatus.measuring;
    notifyListeners();

    _measurementResult =
        isDefinite ? _currentPos : (Random().nextBool() ? '0' : '1');
    _currentPos = _measurementResult; // <-- was missing before

    // Let the UI run its own animation for this duration; provider just waits.
    await Future.delayed(Duration(milliseconds: isDefinite ? 900 : 1200));

    _gameStatus = GameStatus.measuringResult;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));
    _gameStatus = GameStatus.playing;
    updatePlayerAndCard('M');
  }

  Future<void> nodeTransition(String playedCard) async {
    // Ignore any card play while an animation (measurement or otherwise)
    // is already resolving — stops overlapping/duplicate triggers.
    if (_gameStatus != GameStatus.playing) return;

    if (playedCard == 'M') {
      await _handleMeasurement();
      return;
    }

    String? next = QuantumLogic.getNextPosition(_currentPos, playedCard);
    _currentPos = next;

    if (currentPlayer == 1 && _currentPos == '+') {
      _p1Score += 1;
      _lastScorer = 1;
      _gameStatus = GameStatus.touchdown;
      updatePlayerAndCard(playedCard);
    } else if (currentPlayer == 2 && _currentPos == '−') {
      _p2Score += 1;
      _lastScorer = 2;
      _gameStatus = GameStatus.touchdown;
      updatePlayerAndCard(playedCard);
    } else {
      updatePlayerAndCard(playedCard);
    }
    notifyListeners();
  }

  void updatePlayerAndCard(String playedCard) {
    if (currentPlayer == 1) {
      _p1Hand.remove(playedCard);
      _p1History.add(playedCard);

      if (_deck.isNotEmpty) {
        _p1Hand.add(_deck.removeLast());
      }

      _currentPlayer = 2;
    } else {
      _p2Hand.remove(playedCard);
      _p2History.add(playedCard);

      if (_deck.isNotEmpty) {
        _p2Hand.add(_deck.removeLast());
      }

      _currentPlayer = 1;
    }


    if (_deck.isEmpty && _p1Hand.isEmpty && _p2Hand.isEmpty) {
      _gameStatus = GameStatus.gameOver;
      notifyListeners();
      return; 
    }

    if (_gameStatus == GameStatus.touchdown) {
      notifyListeners();
      return;
    }

    _gameStatus = GameStatus.turnHandoff;
    notifyListeners();
    _showTurnHandoff();


//     if (_deck.isEmpty) {
//       if (_p1Hand.isEmpty && _p2Hand.isEmpty) {
//         _gameStatus = GameStatus.gameOver;
//       }
//     }

// _gameStatus = GameStatus.turnHandoff;
//     notifyListeners();
//     _showTurnHandoff();
  }

  Future<void> _showTurnHandoff() async {
  await Future.delayed(const Duration(milliseconds: 1200));
  if (_gameStatus == GameStatus.turnHandoff) {
    _gameStatus = GameStatus.playing;
    notifyListeners();
  }
  }
  

  void performMeasurementAndToss(int result) {
    _currentPos = result.toString();
    _p1History.clear();
    _p2History.clear();
    _gameStatus = GameStatus.playing;
    notifyListeners();
  }
}
