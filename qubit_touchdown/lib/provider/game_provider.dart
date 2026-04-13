import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qubit_touchdown/quantum_logic.dart';
import 'dart:math';

enum GameStatus { playing, touchdown, tossing, tossResult, gameOver }

class GameProvider extends ChangeNotifier {
  
  String _currentPos = '0';
  List<String> _deck = [];
  List<String> _p1Hand = [];
  List<String> _p2Hand = [];
  List<String> _currentDriveGates = [];

  int _currentPlayer = 1;
  int _p1Score = 0;
  int _p2Score = 0;
  

  GameStatus _status = GameStatus.playing;
  String _tossResult = "";
  String _lastScorerName = "";
  String? _idealCircuit;
  String? _transpiledCircuit; 

  // getters 
  String get currentPos => _currentPos;
  int get currentPlayer => _currentPlayer;
  int get p1Score => _p1Score;
  int get p2Score => _p2Score;
  int get deckCount => _deck.length;
  List<String> get currentHand => _currentPlayer == 1 ? _p1Hand : _p2Hand;
  GameStatus get status => _status;
  String get tossResult => _tossResult;
  String get lastScorerName => _lastScorerName;
  String? get idealCircuit => _idealCircuit;
  String? get transpiledCircuit => _transpiledCircuit;

  String get winnerMessage {
    if (_p1Score > _p2Score) return "PLAYER 1 WINS!";
    if (_p2Score > _p1Score) return "PLAYER 2 WINS!";
    return "IT'S A DRAW!";
  }

  void setupGame() {
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

    _p1Hand = [];
    _p2Hand = [];
    _currentDriveGates = [];
    _idealCircuit = null;
    _transpiledCircuit = null;

    for (int i = 0; i < 4; i++) {
      _p1Hand.add(_deck.removeLast());
      _p2Hand.add(_deck.removeLast());
    }

    _currentPos = _performToss();
    _p1Score = 0;
    _p2Score = 0;
    _currentPlayer = 1;
    _status = GameStatus.playing;
    notifyListeners();
  }

  String _performToss() => Random().nextBool() ? '0' : '1';

  void playCard(String gate) {
    if (_status != GameStatus.playing) return;

    if (gate == 'M') {
      _handleMeasurement();
    } else if (gate == 'I') {
      _finalizeTurn(gate);
    } else {
      _handleMovement(gate);
    }
  }

  void _handleMovement(String gate) {
    _currentDriveGates.add(gate);

    String? next = QuantumLogic.getNextPosition(_currentPos, gate);
    if (next != null) {
      _currentPos = next;

      if ((_currentPos == '+' && _currentPlayer == 1) ||
          (_currentPos == '−' && _currentPlayer == 2)) {
        if (_currentPlayer == 1)
          _p1Score++;
        else
          _p2Score++;
        _handleTouchdownPhase();
      } else {
        _finalizeTurn(gate);
      }
    }
  }

  void _handleTouchdownPhase() {
    _status = GameStatus.touchdown;
    _lastScorerName = _currentPlayer == 1 ? "Player 1" : "Player 2";

    updateCircuitForBackend(null);
    notifyListeners();
  }

  Future<void> updateCircuitForBackend(String? backendKey) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/generate_circuit'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"gates": _currentDriveGates, "backend": backendKey}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _idealCircuit = data['ideal_image'];
        _transpiledCircuit = data['transpiled_image']; 
        notifyListeners();
      }

      
    } catch (e) {
      debugPrint("Error fetching hardware transpilation: $e");
    }
  }

  Future<void> performKickoffToss() async {
    _status = GameStatus.tossing;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    _tossResult = _performToss();
    _currentPos = _tossResult;
    _status = GameStatus.tossResult;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));
    _status = GameStatus.playing;
    _currentDriveGates = [];
    _idealCircuit = null;
   _transpiledCircuit = null;

    _finalizeTurn("");
  }

  Future<void> _handleMeasurement() async {
    _status = GameStatus.tossing;
    notifyListeners();

    for (int i = 0; i < 40; i++) {
      _tossResult = Random().nextBool() ? '0' : '1';
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 20));
    }

    _tossResult = _performToss();
    _currentPos = _tossResult;
    _status = GameStatus.tossResult;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));
    _status = GameStatus.playing;
    _finalizeTurn('M');
  }

  void _finalizeTurn(String playedGate) {
    if (playedGate.isNotEmpty) {
      if (_currentPlayer == 1)
        _p1Hand.remove(playedGate);
      else
        _p2Hand.remove(playedGate);

      if (_deck.isNotEmpty) {
        if (_currentPlayer == 1)
          _p1Hand.add(_deck.removeLast());
        else
          _p2Hand.add(_deck.removeLast());
      }
    }
    if (_deck.isEmpty && _p1Hand.isEmpty && _p2Hand.isEmpty) {
      _status = GameStatus.gameOver;
      notifyListeners();
      return;
    }

    _currentPlayer = (_currentPlayer == 1) ? 2 : 1;
    notifyListeners();
  }
}






