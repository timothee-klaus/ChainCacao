import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/cacao_lot_list_provider.dart';
import '../../domain/entities/cacao_lot.dart';
import 'lot_detail_page.dart';
import '../../../../core/services/sync/sync_providers.dart';
import '../../../../core/services/sync/sync_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LotListPage extends ConsumerWidget {
  const LotListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lotsAsync = ref.watch(cacaoLotListNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'MES RÉCOLTES',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.brown[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(cacaoLotListNotifierProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSyncHeader(context, ref),
          Expanded(
            child: lotsAsync.when(
              data: (lots) => lots.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: lots.length,
                      itemBuilder: (context, index) =>
                          _buildLotCard(context, lots[index]),
                    ),
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.brown),
              ),
              error: (err, stack) => Center(child: Text('Erreur: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncHeader(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityProvider);
    final pendingCountAsync = ref.watch(pendingSyncCountProvider);

    final hasConnection = connectivityAsync.when(
      data: (results) => results.any(
        (r) =>
            r == ConnectivityResult.mobile ||
            r == ConnectivityResult.wifi ||
            r == ConnectivityResult.ethernet,
      ),
      loading: () => false,
      error: (error, stack) => false,
    );

    final pendingCount = pendingCountAsync.value ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1E17),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D1E17).withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasConnection ? Icons.wifi_rounded : Icons.wifi_off_rounded,
              color: hasConnection ? Colors.greenAccent : Colors.redAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pendingCountAsync.when(
                    data: (count) =>
                        count > 0 ? '$count LOTS EN LOCAL' : 'TOUT EST À JOUR',
                    loading: () => 'CHARGEMENT...',
                    error: (error, stack) => 'ERREUR SYNCHRO',
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasConnection ? 'Connecté au réseau' : 'Mode hors-ligne',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'La synchronisation sécurise vos récoltes sur la blockchain pour la certification.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 10,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (pendingCount > 0)
            ElevatedButton(
              onPressed: hasConnection
                  ? () => ref.read(syncServiceProvider).triggerSync()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF2D1E17),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'SYNC',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
              ),
            ),
        ],
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
          Text(
            'Aucun lot enregistré',
            style: TextStyle(
              color: Colors.brown[300],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Commencez par ajouter une nouvelle récolte.',
            style: TextStyle(color: Colors.black38, fontSize: 12),
          ),
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
                MaterialPageRoute(
                  builder: (context) => LotDetailPage(lot: lot),
                ),
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
                      color: (isCacao ? Colors.brown[800] : Colors.orange[800])!
                          .withValues(alpha: 0.1),
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
                              lot.species.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                letterSpacing: 0.5,
                              ),
                            ),
                            _buildStatusBadge(lot.syncStatus),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Variété : ${lot.variete.isEmpty ? "Non spécifiée" : lot.variete}',
                          style: TextStyle(
                            color: Colors.brown[400],
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.brown[50],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${lot.weightKg} KG',
                                style: TextStyle(
                                  color: Colors.brown[900],
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Colors.brown[200],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('dd MMM').format(lot.dateCollecte),
                              style: TextStyle(
                                color: Colors.brown[200],
                                fontSize: 11,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.map_outlined,
                              size: 12,
                              color: Colors.brown[200],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              lot.region,
                              style: TextStyle(
                                color: Colors.brown[200],
                                fontSize: 11,
                              ),
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
        label = 'LOCAL';
        icon = Icons.storage;
        break;
      default:
        color = Colors.blueGrey;
        label = 'BROUILLON';
        icon = Icons.edit_note;
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
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
