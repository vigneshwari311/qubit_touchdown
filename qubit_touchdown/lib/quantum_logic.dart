class QuantumLogic {

static final Map<String, Map<String, String>> boardTransitions = {
    '0': {'H': '+', 'X': '1', 'Y': '1', '√X': '−i'},
    '+': {'H': '0'},
    '−i': {'S': '+', '√X': '1', 'X': 'i', 'Z': 'i', 'H': 'i'},
    '1': {'√X': 'i', 'X': '0', 'Y': '0', 'H': '−'},
    'i': {'√X': '0', 'X': '−i', 'Z': '−i', 'H': '−i', 'S': '−'},
    '−': {'H': '1'},
  };
  static String? getNextPosition(String currentPos, String gate) {
    if (boardTransitions.containsKey(currentPos)) {
      return boardTransitions[currentPos]![gate] ?? currentPos;
    }
    return currentPos;
  }
}





