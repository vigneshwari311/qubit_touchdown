import 'package:flutter/material.dart';
import 'package:qubit_touchdown/components/info_page_widgets/shared_info_components.dart';

class QuantumSection extends StatelessWidget {
  const QuantumSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
      children: const [
        SectionHeading(
          tag: '⟩',
          title: 'What is a qubit?',
          color: Color(0xFF1D9E75),
        ),
        ProseCard(
          text:
              'A classical bit is always 0 or 1. A qubit can be in a superposition — '
              'a weighted combination of |0⟩ and |1⟩ at the same time. '
              'On the board, the nodes |0⟩, |1⟩, |+⟩, |−⟩, |i⟩, and |−i⟩ represent '
              'the six cardinal states on the Bloch sphere.',
        ),
        SizedBox(height: 16),
        SectionHeading(
          tag: '⊗',
          title: 'The Bloch sphere',
          color: Color(0xFF1D9E75),
        ),
        ProseCard(
          text:
              'Any single-qubit state can be pictured as a point on the surface of a '
              'unit sphere. The north pole is |0⟩, the south pole is |1⟩, '
              'the equator holds the superpositions. '
              'A quantum gate rotates this sphere. '
              'The Bloch sphere view in-game shows you exactly where the qubit is '
              'after each card you play.',
        ),
        SizedBox(height: 16),
        SectionHeading(
          tag: 'M',
          title: 'Measurement & collapse',
          color: Color(0xFF378ADD),
        ),
        ProseCard(
          text:
              'When you measure a qubit it collapses to a definite 0 or 1. '
              'The probability of each outcome is the square of the state\'s amplitude '
              '(Born rule). After collapsing, the superposition is gone — '
              'that\'s why the M card is powerful and irreversible.',
        ),
        SizedBox(height: 16),
        SectionHeading(
          tag: 'U',
          title: 'Quantum gates',
          color: Color(0xFF378ADD),
        ),
        ProseCard(
          text:
              'Every gate in the game is a unitary matrix — a rotation of the Bloch sphere. '
              'Unitarity means the operation is always reversible (except measurement). '
              'Two identical gates often cancel out: H·H = I, X·X = I.',
        ),
        SizedBox(height: 16),
        SectionHeading(
          tag: '∿',
          title: 'Transpilation',
          color: Color(0xFF9333EA),
        ),
        ProseCard(
         text:
              'Real quantum hardware only understands a native set of parameterized '
              'physical instructions, primarily known as U-gates (U1, U2, and U3). '
              'A transpiler rewrites your high-level card moves—like H, X, or Z—by '
              'adjusting rotation angles (θ, φ, λ) inside these native U-gates. '
              'The "Transpiled circuit" on your touchdown screen shows this exact '
              'machine code, optimized to reduce hardware pulse errors and noise.',
        ),
        SizedBox(height: 12),
        // SectionHeading(
        //   tag: '2Q',
        //   title: 'Two-qubit circuit',
        //   color: Color(0xFF9333EA),
        // ),
        // ProseCard(
        //   text:
        //       'After a game, the combined circuit puts Player 1\'s gates on qubit q₀ '
        //       'and Player 2\'s gates on qubit q₁ in one circuit. '
        //       'Both qubits are measured at the end. '
        //       'This lets you run both players\' move sequences on one piece of real quantum hardware '
        //       'and see the joint outcome.',
        // ),
      ],
    );
  }
}
