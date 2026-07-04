import 'dart:convert';
import 'package:flutter/material.dart';

class QuantumCircuitDisplay extends StatelessWidget {
  final String label;
  final String? imageB64;
  final String emptyMessage;

  const QuantumCircuitDisplay({
    super.key,
    required this.label,
    required this.imageB64,
    this.emptyMessage =
        "No moves made yet or gates canceled out — identity circuit",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child:
              imageB64 != null
                  ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white24, width: 1.5),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Image.memory(base64Decode(imageB64!)),
                    ),
                  )
                  : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 28,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white24, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        emptyMessage,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
        ),
      ],
    );
  }
}
