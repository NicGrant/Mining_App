import 'package:flutter/material.dart';
import '/ui/hex_background.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base color + gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1B1B1B),
                Color(0xFF121212),
              ],
            ),
          ),
        ),

        // Hex pattern overlay
        const HexBackground(),

        // Page content
        SafeArea(child: child),
      ],
    );
  }
}