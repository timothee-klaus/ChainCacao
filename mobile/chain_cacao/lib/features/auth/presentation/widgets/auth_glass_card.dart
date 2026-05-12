import 'dart:ui';
import 'package:flutter/material.dart';

class AuthGlassCard extends StatelessWidget {
  final Widget child;
  final double opacity;

  const AuthGlassCard({super.key, required this.child, this.opacity = 0.6});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}
