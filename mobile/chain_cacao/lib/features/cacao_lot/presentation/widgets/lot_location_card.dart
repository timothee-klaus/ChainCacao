import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/cacao_lot_form_controller.dart';

class LotLocationCard extends ConsumerWidget {
  const LotLocationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cacaoLotFormControllerProvider);
    final controller = ref.read(cacaoLotFormControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: state.isLocationCaptured 
            ? [Colors.green[800]!, Colors.green[900]!] 
            : [Colors.brown[700]!, Colors.brown[900]!],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(state.isLocationCaptured ? Icons.gps_fixed : Icons.gps_not_fixed, color: Colors.white70),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('LOCALISATION GPS', style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
                Text(
                  state.isLocationCaptured 
                    ? '${state.latitude!.toStringAsFixed(4)}, ${state.longitude!.toStringAsFixed(4)}' 
                    : (state.isCapturingLocation ? 'Recherche en cours...' : 'Non définie'),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: state.isCapturingLocation ? null : controller.captureLocation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white24,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: state.isCapturingLocation 
              ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text(state.isLocationCaptured ? 'ACTUALISER' : 'CAPTURER'),
          ),
        ],
      ),
    );
  }
}
