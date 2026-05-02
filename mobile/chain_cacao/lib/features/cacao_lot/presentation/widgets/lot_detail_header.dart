import 'package:flutter/material.dart';
import '../../domain/entities/cacao_lot.dart';

class LotDetailHeader extends StatelessWidget {
  final CacaoLot lot;

  const LotDetailHeader({super.key, required this.lot});

  @override
  Widget build(BuildContext context) {
    final isCacao = lot.species.toLowerCase().contains('cacao');
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.brown[900]!,
            Colors.brown[800]!,
          ],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusBadge(lot.syncStatus),
              Icon(
                isCacao ? Icons.eco : Icons.coffee,
                color: Colors.white24,
                size: 40,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '${lot.weightKg} KG',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          Text(
            '${lot.species.toUpperCase()} - ${lot.variete.toUpperCase()}',
            style: TextStyle(
              color: Colors.orange[400],
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isSynced = status.toLowerCase() == 'synced';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSynced ? Icons.link : Icons.storage,
            size: 12,
            color: isSynced ? Colors.green[400] : Colors.orange[400],
          ),
          const SizedBox(width: 8),
          Text(
            isSynced ? 'SECURED ON CHAIN' : 'LOCAL DRAFT',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 9,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
