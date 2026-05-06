import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../domain/entities/cacao_lot.dart';
import '../../../../core/presentation/providers/nav_provider.dart';

class LotSuccessPage extends ConsumerWidget {
  final CacaoLot lot;

  const LotSuccessPage({super.key, required this.lot});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          // Background Decoration
          Positioned(
            top: -100,
            right: -100,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: Colors.brown[50]!.withValues(alpha: 0.5),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  
                  // Animated-like Success Badge (BROWN)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withValues(alpha: 0.15),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.brown[900],
                      size: 64,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    'RÉCOLTE SÉCURISÉE',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: Colors.brown[900],
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Votre lot a été authentifié et enregistré avec succès dans le registre local.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.brown[400],
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // QR Code Premium Card (BROWN)
                  _buildQRCodeCard(),
                  
                  const SizedBox(height: 32),
                  
                  // Quick Stats Row
                  _buildQuickStats(),
                  
                  const Spacer(),
                  
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        // On change d'onglet d'abord
                        ref.read(navIndexProvider.notifier).state = 2;
                        // On retourne à l'accueil (MainNavigationShell)
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[900],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                        shadowColor: Colors.brown.withValues(alpha: 0.4),
                      ),
                      child: const Text(
                        'RETOUR À L\'INVENTAIRE',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          QrImageView(
            data: lot.lotId,
            version: QrVersions.auto,
            size: 180.0,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Colors.brown[900],
            ),
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.brown[900],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'CERTIFICAT #${lot.lotId.length > 8 ? lot.lotId.substring(0, 8).toUpperCase() : lot.lotId.toUpperCase()}',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.brown[300],
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('POIDS', '${lot.weightKg} Kg'),
        Container(width: 1, height: 30, color: Colors.grey[300]),
        _buildStatItem('ESPÈCE', '${lot.species} (${lot.variete.isEmpty ? "Non spécifiée" : lot.variete})'),
        Container(width: 1, height: 30, color: Colors.grey[300]),
        _buildStatItem('RÉGION', lot.region),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: Colors.grey[400],
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF3E2723),
          ),
        ),
      ],
    );
  }
}
