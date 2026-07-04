import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeading extends StatelessWidget {
  final String tag;
  final String title;
  final Color color;

  const SectionHeading({
    super.key,
    required this.tag,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color.withAlpha(80), width: 0.5),
            ),
            child: Center(
              child: Text(
                tag,
                style: GoogleFonts.jetBrainsMono(
                  color: color,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class ProseCard extends StatelessWidget {
  final String text;
  const ProseCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1218),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E2230), width: 0.5),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: const Color(0xFF8B8FA8),
          fontSize: 12,
          height: 1.65,
        ),
      ),
    );
  }
}

class StepTile extends StatelessWidget {
  final String title;
  final String body;
  final Color accent;

  const StepTile({
    super.key,
    required this.title,
    required this.body,
    this.accent = const Color(0xFF534AB7),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1218),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E2230), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 5, right: 8),
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.rajdhani(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF8B8FA8),
                    fontSize: 11,
                    height: 1.55,
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
