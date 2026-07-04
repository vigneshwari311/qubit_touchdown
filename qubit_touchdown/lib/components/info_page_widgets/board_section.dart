import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qubit_touchdown/components/info_page_widgets/shared_info_components.dart';

class BoardSection extends StatelessWidget {
  const BoardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
      children: [
        const SectionHeading(
          tag: '◆',
          title: 'The nodes',
          color: Color(0xFFF5C518),
        ),
        const ProseCard(
          text:
              'The six nodes map to the six cardinal points of the Bloch sphere. '
              '|+⟩ is Player 1\'s end zone (north equator). '
              '|−⟩ is Player 2\'s end zone (south equator). '
              '|0⟩ and |1⟩ are the poles. |i⟩ and |−i⟩ are the east-west equator.',
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F1218),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1E2230), width: 0.5),
          ),
          child: Column(
            children: const [
              NodeRow(
                '|+⟩',
                'North equator',
                'P1 end zone',
                Color(0xFF378ADD),
                isHeader: true,
              ),
              NodeRow(
                '|0⟩',
                'North pole',
                'Computational basis state',
                Color(0xFFF5C518),
              ),
              NodeRow(
                '|−i⟩',
                'East equator',
                'Y-axis state',
                Color(0xFFF5C518),
              ),
              NodeRow('|i⟩', 'West equator', 'Y-axis state', Color(0xFFF5C518)),
              NodeRow(
                '|1⟩',
                'South pole',
                'Computational basis state',
                Color(0xFFF5C518),
              ),
              NodeRow(
                '|−⟩',
                'South equator',
                'P2 end zone',
                Color(0xFFD4537E),
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const SectionHeading(
          tag: '→',
          title: 'The edges',
          color: Color(0xFFF5C518),
        ),
        const ProseCard(
          text:
              'Each edge is labelled with the gate(s) that move along it. '
              'Plain lines are bidirectional. '
              'Arrowed lines are one-way — you can only travel in the arrow\'s direction.',
        ),
        const SizedBox(height: 12),
        ...[
          (
            'H',
            'Bidirectional',
            '|0⟩ ↔ |+⟩ and |1⟩ ↔ |−⟩',
            const Color(0xFF8B0000),
          ),
          (
            'S',
            'One-way arrow',
            '|−i⟩ → |+⟩ and |i⟩ → |−⟩',
            const Color(0xFF006064),
          ),
          (
            'X, Y',
            'Bidirectional',
            '|0⟩ ↔ |1⟩ and |i⟩ ↔ |−i⟩',
            const Color(0xFFD35400),
          ),
          ('X, Z, H', 'Bidirectional', '|−i⟩ ↔ |i⟩', const Color(0xFF006064)),
          (
            '√X',
            'One-way arrow',
            '|0⟩→|−i⟩, |1⟩→|i⟩, |i⟩→|0⟩, |−i⟩→|1⟩',
            const Color(0xFF4E342E),
          ),
        ].map((e) => EdgeRow(gate: e.$1, type: e.$2, moves: e.$3, color: e.$4)),
      ],
    );
  }
}

class NodeRow extends StatelessWidget {
  final String state;
  final String position;
  final String note;
  final Color color;
  final bool isHeader;
  final bool isLast;

  const NodeRow(
    this.state,
    this.position,
    this.note,
    this.color, {
    super.key,
    this.isHeader = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        border:
            isLast
                ? null
                : const Border(
                  bottom: BorderSide(color: Color(0xFF1E2230), width: 0.5),
                ),
        color: isHeader || isLast ? color.withAlpha(15) : Colors.transparent,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 38,
            child: Text(
              state,
              style: GoogleFonts.jetBrainsMono(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              position,
              style: GoogleFonts.inter(
                color: const Color(0xFF8B8FA8),
                fontSize: 11,
              ),
            ),
          ),
          Text(
            note,
            style: GoogleFonts.inter(
              color: const Color(0xFF4A4D5A),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class EdgeRow extends StatelessWidget {
  final String gate;
  final String type;
  final String moves;
  final Color color;

  const EdgeRow({
    super.key,
    required this.gate,
    required this.type,
    required this.moves,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1218),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E2230), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              gate,
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: GoogleFonts.rajdhani(
                    color: const Color(0xFF8B8FA8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  moves,
                  style: GoogleFonts.jetBrainsMono(
                    color: const Color(0xFF5DCAA5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
