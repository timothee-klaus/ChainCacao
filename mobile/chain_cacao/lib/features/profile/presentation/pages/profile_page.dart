import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cacao_lot/presentation/providers/cacao_lot_list_provider.dart';
import '../../../cacao_lot/domain/entities/cacao_lot.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final lotsAsync = ref.watch(cacaoLotListNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'MON PROFIL',
          style: TextStyle(
            color: Color(0xFF2D1E17),
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(user),
            _buildStatsSection(lotsAsync),
            const SizedBox(height: 32),
            _buildMenuSection(context, ref),
            const SizedBox(height: 40),
            _buildVersionInfo(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User? user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE67E22), width: 2),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFF0F2F5),
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?u=farmer',
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D1E17),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            user?.nomAffiche ?? 'Agriculteur',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D1E17),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Producteur Certifié · ${user?.userId != null ? (user!.userId.length > 8 ? user.userId.substring(0, 8) : user.userId).toUpperCase() : "ID-INV"}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE67E22).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, color: Color(0xFFE67E22), size: 14),
                SizedBox(width: 6),
                Text(
                  'STATUT EUDR : CONFORME',
                  style: TextStyle(
                    color: Color(0xFFE67E22),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(AsyncValue<List<CacaoLot>> lotsAsync) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2D1E17),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2D1E17).withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: lotsAsync.when(
            data: (lots) {
              final totalWeight = lots.fold(
                0.0,
                (sum, lot) => sum + lot.weightKg,
              );
              final syncedCount = lots
                  .where((l) => l.syncStatus == 'synced')
                  .length;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('RÉCOLTES', '${lots.length}'),
                  Container(width: 1, height: 40, color: Colors.white24),
                  _buildStatItem(
                    'POIDS TOTAL',
                    '${totalWeight.toStringAsFixed(0)} KG',
                  ),
                  Container(width: 1, height: 40, color: Colors.white24),
                  _buildStatItem('SYNCHRONISÉS', '$syncedCount'),
                ],
              );
            },
            loading: () => const SizedBox(
              height: 40,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
            error: (err, _) => Text(
              'Erreur stats',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            _buildMenuItem(
              Icons.person_outline,
              'Mon Compte',
              'Gérez vos infos personnelles',
            ),
            _buildDivider(),
            _buildMenuItem(
              Icons.lock_outline,
              'Sécurité',
              'Code PIN et Biométrie',
            ),
            _buildDivider(),
            _buildMenuItem(Icons.language_outlined, 'Langue', 'Français (FR)'),
            _buildDivider(),
            _buildMenuItem(
              Icons.logout,
              'Déconnexion',
              'Quitter la session en toute sécurité',
              isDestructive: true,
              onTap: () => ref.read(authProvider.notifier).logout(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle, {
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    final color = isDestructive ? Colors.red[700] : const Color(0xFF2D1E17);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color!.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 15,
          color: color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey[100], indent: 70);
  }

  Widget _buildVersionInfo() {
    return Column(
      children: [
        const Text(
          'ChainCacao v1.0.4',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Propulsé par la Blockchain Miabe',
          style: TextStyle(color: Colors.grey[400], fontSize: 10),
        ),
      ],
    );
  }
}
