import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../controllers/cacao_lot_list_controller.dart';
import '../../domain/entities/cacao_lot.dart';
import 'lot_detail_page.dart';

class LotListPage extends ConsumerWidget {
  const LotListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lotsAsync = ref.watch(cacaoLotListControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('MES RÉCOLTES', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.brown[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(cacaoLotListControllerProvider.notifier).refresh(),
          ),
        ],
      ),
      body: lotsAsync.when(
        data: (lots) => lots.isEmpty 
          ? _buildEmptyState() 
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: lots.length,
              itemBuilder: (context, index) => _buildLotCard(context, lots[index]),
            ),
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.brown)),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.brown[100]),
          const SizedBox(height: 16),
          Text('Aucun lot enregistré', style: TextStyle(color: Colors.brown[300], fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Commencez par ajouter une nouvelle récolte.', style: TextStyle(color: Colors.black38, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLotCard(BuildContext context, CacaoLot lot) {
    final isCacao = lot.species.toLowerCase().contains('cacao');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.brown[50]!),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LotDetailPage(lot: lot)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Icone ou Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: (isCacao ? Colors.brown[800] : Colors.orange[800])!.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      isCacao ? Icons.eco : Icons.coffee,
                      color: isCacao ? Colors.brown[800] : Colors.orange[800],
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Détails
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${lot.weightKg} Kg - ${lot.species}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                            ),
                            _buildStatusBadge(lot.syncStatus),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Variété: ${lot.variete.isEmpty ? "Non spécifiée" : lot.variete}',
                          style: TextStyle(color: Colors.brown[400], fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 12, color: Colors.brown[200]),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('dd MMM yyyy à HH:mm').format(lot.dateCollecte),
                              style: TextStyle(color: Colors.brown[200], fontSize: 11),
                            ),
                            const Spacer(),
                            Icon(Icons.map_outlined, size: 12, color: Colors.brown[200]),
                            const SizedBox(width: 4),
                            Text(
                              lot.region,
                              style: TextStyle(color: Colors.brown[200], fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'synced':
        color = Colors.green;
        label = 'CHAIN';
        icon = Icons.link; // Icône pour Blockchain
        break;
      case 'pending':
        color = Colors.orange;
        label = 'ATTENTE';
        icon = Icons.sync;
        break;
      default:
        color = Colors.blueGrey;
        label = 'LOCAL';
        icon = Icons.storage;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}
