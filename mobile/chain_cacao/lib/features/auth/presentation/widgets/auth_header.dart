import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo circulaire réduit pour l'alignement horizontal
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.brown.withValues(alpha: 0.2)),
          ),
          child: Image.asset('assets/images/logo.png', height: 50),
        ),
        const SizedBox(width: 16),
        // Bloc Texte
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ChainCacao',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: Colors.brown[900],
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Solution blockchain de traçabilité pour la filière café-cacao au Togo.',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
