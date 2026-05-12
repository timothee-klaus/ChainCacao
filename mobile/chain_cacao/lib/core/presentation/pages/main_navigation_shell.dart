import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../features/cacao_lot/presentation/pages/add_lot_page.dart';
import '../../../features/cacao_lot/presentation/pages/lot_list_page.dart';
import '../../../features/sales/presentation/pages/vente_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';

import '../providers/nav_provider.dart';

class MainNavigationShell extends ConsumerStatefulWidget {
  const MainNavigationShell({super.key});

  @override
  ConsumerState<MainNavigationShell> createState() =>
      _MainNavigationShellState();
}

class _MainNavigationShellState extends ConsumerState<MainNavigationShell> {
  // int _selectedIndex = 0; // Removed local state

  final List<Widget> _pages = [
    const DashboardPage(),
    const AddLotPage(),
    const LotListPage(),
    const VentePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(navIndexProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: selectedIndex, children: _pages),
      bottomNavigationBar: _buildBottomNav(selectedIndex),
    );
  }

  Widget _buildBottomNav(int selectedIndex) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // Plus gris
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, 'ACCUEIL', selectedIndex),
              _buildNavItem(
                1,
                Icons.add_circle_outline,
                'AJOUTER',
                selectedIndex,
              ),
              _buildNavItem(
                2,
                Icons.inventory_2_outlined,
                'MES LOTS',
                selectedIndex,
              ),
              _buildNavItem(3, Icons.swap_horiz, 'VENTE', selectedIndex),
              _buildNavItem(4, Icons.person_outline, 'PROFIL', selectedIndex),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    int selectedIndex,
  ) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => ref.read(navIndexProvider.notifier).state = index,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2D1E17) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF2D1E17).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF9BA3AF),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF9BA3AF),
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
