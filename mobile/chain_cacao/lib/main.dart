import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/sync/sync_service.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/cacao_lot/presentation/pages/add_lot_page.dart';
import 'features/cacao_lot/presentation/pages/lot_list_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'ChainCacao',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          primary: Colors.brown[900]!,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: authState.user != null
          ? const MyHomePage(title: 'ChainCacao Dashboard')
          : const LoginPage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.brown[900],
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.brown[900]),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(),
            const SizedBox(height: 32),
            _buildQuickActions(),
            const SizedBox(height: 32),
            _buildSyncStatusCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddLotPage()),
        ),
        label: const Text(
          'NOUVELLE RÉCOLTE',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        icon: const Icon(Icons.add_a_photo_outlined),
        backgroundColor: Colors.brown[900],
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    final user = ref.watch(authProvider).user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bonjour,',
          style: TextStyle(color: Colors.brown[400], fontSize: 16),
        ),
        Text(
          user?.nomAffiche ?? 'Agriculteur',
          style: TextStyle(
            color: Colors.brown[900],
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.orange[800],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ACTIONS RAPIDES',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: Colors.black38,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildActionCard(
              context,
              'Mes Récoltes',
              Icons.inventory_2_outlined,
              Colors.brown[800]!,
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
              Colors.orange[900]!,
              () {}, // À implémenter
            ),
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
            border: Border.all(color: color.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSyncStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.brown[900],
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: const NetworkImage(
            'https://www.transparenttextures.com/patterns/carbon-fibre.png',
          ),
          opacity: 0.1,
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SYNCHRONISATION',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'État de la Blockchain',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'En attente',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      '0 lot(s)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => ref.read(syncServiceProvider).triggerSync(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'SYNCHRONISER',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
