import 'dart:ui';

class CardData {
  final String symbol;
  final String name;
  final int count;
  final Color color;
  final String effect;
  final String quantum;

  const CardData({
    required this.symbol,
    required this.name,
    required this.count,
    required this.color,
    required this.effect,
    required this.quantum,
  });
}
