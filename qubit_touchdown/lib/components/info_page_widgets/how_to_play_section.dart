import 'package:flutter/material.dart';
import 'package:qubit_touchdown/components/info_page_widgets/shared_info_components.dart';


class HowToPlaySection extends StatelessWidget {
  const HowToPlaySection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
      children: [
        SectionHeading(
          tag: '01',
          title: 'Objective',
          color: const Color(0xFF534AB7),
        ),
        ProseCard(
          text:
              'Move the qubit to your end zone. '
              'Player 1 scores by reaching |+⟩. '
              'Player 2 scores by reaching |−⟩. '
              'The player with the most touchdowns when the deck runs out wins.',
        ),
        const SizedBox(height: 16),
        SectionHeading(
          tag: '02',
          title: 'Turn structure',
          color: const Color(0xFF534AB7),
        ),
        ...[
          (
            'Play a card',
            'Pick one gate card from your hand and tap it. The qubit moves along the board edge that matches your gate.',
          ),
          (
            'Draw a card',
            'After playing, you automatically draw from the deck to keep 4 cards in hand.',
          ),
          (
            'Pass turn',
            'Play the I (identity) card to pass without moving the qubit.',
          ),
          (
            'Measure',
            'Play the M card to collapse a superposition. The qubit collapses to |0⟩ or |1⟩ probabilistically.',
          ),
        ].map((e) => StepTile(title: e.$1, body: e.$2)),
        const SizedBox(height: 16),
        SectionHeading(
          tag: '03',
          title: 'Scoring',
          color: const Color(0xFF534AB7),
        ),
        ProseCard(
          text:
              'Each touchdown scores 1 point. After a score, a quantum coin toss '
              '(H gate on |0⟩ then measure) decides who kicks off next. '
              'The game ends when both hands and the deck are empty.',
        ),
        const SizedBox(height: 16),
        SectionHeading(
          tag: '04',
          title: 'Tips',
          color: const Color(0xFF1D9E75),
        ),
        ...[
          (
            'Block, don\'t just advance',
            'Moving the qubit away from your opponent\'s end zone is as useful as advancing toward yours.',
          ),
          (
            'Save your M card',
            'Measuring from superposition is 50/50. Use it when you\'re stuck in the middle.',
          ),
          (
            'Watch the arrows',
            'Some edges are one-way (√X). Plan two moves ahead.',
          ),
        ].map(
          (e) => StepTile(
            title: e.$1,
            body: e.$2,
            accent: const Color(0xFF1D9E75),
          ),
        ),
      ],
    );
  }
}
