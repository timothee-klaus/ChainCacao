import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cacao_lot/presentation/pages/lot_list_page.dart';
import '../../../../core/services/sync/sync_service.dart';
import '../../../parcelle/presentation/pages/parcelle_list_page.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPremiumHeader(ref),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  _buildQuickActions(context, ref),
                  const SizedBox(height: 32),
                  _buildSyncStatusCard(ref),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour,',
                    style: TextStyle(
                      color: Colors.brown[300],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.nomAffiche ?? 'Agriculteur',
                    style: TextStyle(
                      color: Colors.brown[900],
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.brown[50]!, width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://ui-avatars.com/api/?name=${user?.nomAffiche ?? "A"}&background=3E2723&color=fff',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildQuickStats(),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.brown[50]!),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildHeaderStat('RÉCOLTES', '12', Icons.eco_outlined),
          _buildDivider(),
          _buildHeaderStat('COOP', 'SCOOPS', Icons.business_outlined),
          _buildDivider(),
          _buildHeaderStat('QUALITÉ', 'A+', Icons.verified_outlined),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 25,
      width: 1,
      color: Colors.brown[50],
    );
  }

  Widget _buildHeaderStat(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.brown[900], size: 16),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.brown[300],
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: Colors.brown[900],
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ACTIONS RAPIDES',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildActionCard(
              context,
              'Mes Récoltes',
              Icons.inventory_2_outlined,
              const Color(0xFF2D1E17),
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LotListPage()),
              ),
            ),
            const SizedBox(width: 16),
            _buildActionCard(
              context,
              'Statistiques',
              Icons.analytics_outlined,
              const Color(0xFFE67E22),
              () {}, // À implémenter
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildActionCard(
              context,
              'Mes Parcelles',
              Icons.map_outlined,
              const Color(0xFF27AE60),
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ParcelleListPage()),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSyncStatusCard(WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1E17),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D1E17).withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.hub_outlined, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'SYNCHRONISATION',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lots en attente',
                      style: TextStyle(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '0 lot(s)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => ref.read(syncServiceProvider).triggerSync(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2D1E17),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.sync, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'SYNC',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
