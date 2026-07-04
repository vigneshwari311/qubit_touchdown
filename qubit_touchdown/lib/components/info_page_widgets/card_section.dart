import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qubit_touchdown/components/info_page_widgets/shared_info_components.dart';
import 'package:qubit_touchdown/models/card_data.dart';

class CardsSection extends StatelessWidget {
  const CardsSection({super.key});

  static const _cards = [
    CardData(
      symbol: 'H',
      name: 'Hadamard',
      count: 7,
      color: Color(0xFF8B0000),
      effect:
          'Puts the qubit into superposition or collapses it back. Moves between |0⟩↔|+⟩ and |1⟩↔|−⟩.',
      quantum:
          'Rotates the Bloch sphere 180° around the X+Z axis. Creates an equal 50/50 mix of |0⟩ and |1⟩.',
    ),
    CardData(
      symbol: 'S',
      name: 'Phase (S)',
      count: 7,
      color: Color(0xFF006064),
      effect: 'Adds a quarter-turn phase. Moves between |+⟩↔|−i⟩ and |−⟩↔|i⟩.',
      quantum:
          'Rotates 90° around the Z axis. Does not change measurement probability — only the phase of the state.',
    ),
    CardData(
      symbol: 'Z',
      name: 'Pauli-Z',
      count: 7,
      color: Color(0xFF006064),
      effect: 'Flips phase. Moves between |−i⟩↔|i⟩ on the board.',
      quantum:
          'Rotates 180° around the Z axis. Leaves |0⟩ and |1⟩ unchanged but flips the sign of |1⟩.',
    ),
    CardData(
      symbol: 'X',
      name: 'Pauli-X',
      count: 4,
      color: Color(0xFFD35400),
      effect: 'The quantum NOT gate. Moves between |0⟩↔|1⟩ and |i⟩↔|−i⟩.',
      quantum:
          'Rotates 180° around the X axis. Flips |0⟩ to |1⟩ and vice versa — a bit-flip.',
    ),
    CardData(
      symbol: 'Y',
      name: 'Pauli-Y',
      count: 9,
      color: Color(0xFFD35400),
      effect:
          'Combines X and Z effects. Also moves between |0⟩↔|1⟩ and |i⟩↔|−i⟩.',
      quantum:
          'Rotates 180° around the Y axis. Flips the qubit and adds a phase.',
    ),
    CardData(
      symbol: '√X',
      name: '√X Gate',
      count: 12,
      color: Color(0xFF4E342E),
      effect:
          'Quarter-turn. Moves along directed (one-way) arrows on the board. Most abundant card in the deck.',
      quantum:
          'Square root of X. Rotates 90° around the X axis. A native gate on most IBM hardware.',
    ),
    CardData(
      symbol: 'I',
      name: 'Identity',
      count: 3,
      color: Color(0xFF2A2D35),
      effect: 'Pass your turn without moving the qubit.',
      quantum: 'Does absolutely nothing to the quantum state. Useful filler.',
    ),
    CardData(
      symbol: 'M',
      name: 'Measure',
      count: 3,
      color: Color(0xFF1A3A2A),
      effect:
          'Collapse the qubit. From |0⟩/|1⟩ it stays put. From superposition it collapses randomly to |0⟩ or |1⟩.',
      quantum:
          'Quantum measurement in the computational basis. Destroys superposition and entanglement. The Born rule governs outcome probability.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
      children: [
        const ProseCard(
          text:
              'There are 52 cards in the deck split across 8 gate types. Each player holds 4 cards at a time.',
        ),
        const SizedBox(height: 12),
        ..._cards.map((c) => CardDetailTile(data: c)),
      ],
    );
  }
}

class CardDetailTile extends StatefulWidget {
  final CardData data;
  const CardDetailTile({super.key, required this.data});

  @override
  State<CardDetailTile> createState() => _CardDetailTileState();
}

class _CardDetailTileState extends State<CardDetailTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.data;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1218),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _expanded ? c.color.withAlpha(180) : const Color(0xFF1E2230),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 52,
                    decoration: BoxDecoration(
                      color: c.color,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: Colors.white.withAlpha(30),
                        width: 0.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        c.symbol,
                        style: GoogleFonts.jetBrainsMono(
                          color: Colors.white,
                          fontSize: c.symbol.length > 1 ? 12 : 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              c.name,
                              style: GoogleFonts.rajdhani(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: .5,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: c.color.withAlpha(40),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: c.color.withAlpha(80),
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                '×${c.count}',
                                style: GoogleFonts.jetBrainsMono(
                                  color: c.color.withAlpha(220),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          c.effect,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF8B8FA8),
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF4A4D5A),
                    size: 18,
                  ),
                ],
              ),
            ),
            if (_expanded)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: c.color.withAlpha(15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: c.color.withAlpha(40),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.blur_circular_outlined,
                        size: 13,
                        color: c.color.withAlpha(180),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          c.quantum,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF8B8FA8),
                            fontSize: 11,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
