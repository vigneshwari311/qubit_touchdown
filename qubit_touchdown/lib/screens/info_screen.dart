import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qubit_touchdown/components/info_page_widgets/board_section.dart';
import 'package:qubit_touchdown/components/info_page_widgets/card_section.dart';
import 'package:qubit_touchdown/components/info_page_widgets/how_to_play_section.dart';
import 'package:qubit_touchdown/components/info_page_widgets/quantum_section.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  int _activeSection = 0;

  static const List<({String label, IconData icon})> _sections = [
    (label: 'HOW TO PLAY', icon: Icons.sports_football_outlined),
    (label: 'CARDS', icon: Icons.style_outlined),
    (label: 'QUANTUM', icon: Icons.blur_circular_outlined),
    (label: 'BOARD', icon: Icons.grid_on_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0E14),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Color(0xFF8B8FA8),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'GUIDE',
          style: GoogleFonts.orbitron(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 2.5,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: const Color(0xFF1E2230)),
        ),
      ),
      body: Column(
        children: [
          // Tab nav
          Container(
            color: const Color(0xFF0B0E14),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              children: List.generate(_sections.length, (i) {
                final active = i == _activeSection;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _activeSection = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            active
                                ? const Color(0xFF1A1D26)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              active
                                  ? const Color(0xFF534AB7)
                                  : const Color(0xFF1E2230),
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _sections[i].icon,
                            size: 14,
                            color:
                                active
                                    ? const Color(0xFFAFA9EC)
                                    : const Color(0xFF4A4D5A),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _sections[i].label,
                            style: GoogleFonts.orbitron(
                              fontSize: 7,
                              fontWeight: FontWeight.w600,
                              color:
                                  active
                                      ? const Color(0xFFAFA9EC)
                                      : const Color(0xFF4A4D5A),
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 12),

          // Content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildSection(_activeSection),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(int index) {
    switch (index) {
      case 0:
        return const HowToPlaySection();
      case 1:
        return const CardsSection();
      case 2:
        return const QuantumSection();
      case 3:
        return const BoardSection();
      default:
        return const SizedBox.shrink();
    }
  }
}
