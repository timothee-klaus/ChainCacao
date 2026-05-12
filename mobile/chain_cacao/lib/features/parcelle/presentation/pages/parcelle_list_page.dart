import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/parcelle_provider.dart';
import '../widgets/parcelle_card.dart';
import 'add_parcelle_page.dart';
import 'parcelle_map_page.dart';

class ParcelleListPage extends ConsumerWidget {
  const ParcelleListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(parcelleNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'GESTION DES PARCELLES',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A1A),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.parcelles.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.parcelles.length,
              itemBuilder: (context, index) {
                final parcelle = state.parcelles[index];
                return ParcelleCard(
                  parcelle: parcelle,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParcelleMapPage(parcelle: parcelle),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleNewParcelle(context, ref),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text(
          'ENREGISTRER UNE PARCELLE',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.brown[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.map_outlined, size: 64, color: Colors.brown[200]),
          ),
          const SizedBox(height: 24),
          const Text(
            'Aucune parcelle enregistrée',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enregistrez vos parcelles pour mieux\ngérer votre production de cacao.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNewParcelle(BuildContext context, WidgetRef ref) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context.mounted) {
          Navigator.pop(context); // Close loading
          _showError(
            context,
            'Veuillez activer le service de localisation GPS.',
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (context.mounted) {
            Navigator.pop(context); // Close loading
            _showError(
              context,
              'La permission de localisation est nécessaire.',
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          Navigator.pop(context); // Close loading
          _showError(
            context,
            'Les permissions sont refusées de façon permanente.',
          );
        }
        return;
      }

      // Pre-fetch position to ensure map starts at the right place
      await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (context.mounted) {
        Navigator.pop(context); // Close loading
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddParcellePage()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading
        _showError(context, 'Erreur lors de l\'initialisation GPS : $e');
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[800],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
