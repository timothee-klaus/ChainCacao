import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../transfer/presentation/providers/transfer_provider.dart';
import '../../../cacao_lot/presentation/providers/cacao_lot_list_provider.dart';
import '../../../cacao_lot/domain/entities/cacao_lot.dart';

class VentePage extends ConsumerWidget {
  const VentePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transferState = ref.watch(transferNotifierProvider);
    final lotsAsync = ref.watch(cacaoLotListNotifierProvider);

    // Écouter les changements d'état pour les effets de bord (Snackbars)
    ref.listen(transferNotifierProvider, (previous, next) {
      if (next.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Transfert initié avec succès !'),
            backgroundColor: Colors.green[800],
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(transferNotifierProvider.notifier).reset();
      }
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red[800],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'VENTE & TRANSFERT',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: const Color(0xFF2D1E17),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTransferHeader(ref, transferState),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('1. SÉLECTION DES LOTS'),
                  const SizedBox(height: 16),
                  lotsAsync.when(
                    data: (lots) =>
                        _buildLotSelection(ref, lots, transferState),
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2D1E17),
                      ),
                    ),
                    error: (e, _) => Text('Erreur: $e'),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('2. DESTINATION (COOPÉRATIVE)'),
                  const SizedBox(height: 16),
                  _buildCoopDropdown(ref, transferState),
                  const SizedBox(height: 32),
                  _buildSectionTitle('3. TRANSPORTEUR'),
                  const SizedBox(height: 16),
                  _buildTransporterDropdown(ref, transferState),
                  const SizedBox(height: 40),
                  _buildSummary(transferState),
                  const SizedBox(height: 24),
                  _buildSubmitButton(ref, transferState),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferHeader(WidgetRef ref, TransferFormState state) {
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
            child: const Icon(
              Icons.local_shipping_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PRÉPARATION D\'EXPÉDITION',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.selectedLots.length} lot(s) sélectionné(s)',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Les lots transférés seront assignés au transporteur pour livraison à la coopérative.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 10,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildLotSelection(
    WidgetRef ref,
    List<CacaoLot> lots,
    TransferFormState state,
  ) {
    if (lots.isEmpty) {
      return const Text('Aucun lot disponible pour la vente.');
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: lots.length,
        itemBuilder: (context, index) {
          final lot = lots[index];
          final isSelected = state.selectedLots.any(
            (l) => l.lotId == lot.lotId,
          );

          return GestureDetector(
            onTap: () =>
                ref.read(transferNotifierProvider.notifier).toggleLot(lot),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2D1E17) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2D1E17)
                      : Colors.grey[200]!,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF2D1E17).withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    lot.species.toLowerCase().contains('cacao')
                        ? Icons.eco
                        : Icons.coffee,
                    color: isSelected ? Colors.white : Colors.brown,
                    size: 20,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lot.lotId.substring(0, 8),
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${lot.weightKg} KG',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF2D1E17),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoopDropdown(WidgetRef ref, TransferFormState state) {
    return _buildDropdownContainer(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: state.selectedCoop,
          hint: const Text('Choisir une coopérative'),
          isExpanded: true,
          items: ['SCOOPS-Togo', 'SOCOOPAD', 'COOP-CA'].map((coop) {
            return DropdownMenuItem(
              value: coop,
              child: Text(
                coop,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
          onChanged: (val) =>
              ref.read(transferNotifierProvider.notifier).setCoop(val),
        ),
      ),
    );
  }

  Widget _buildTransporterDropdown(WidgetRef ref, TransferFormState state) {
    return _buildDropdownContainer(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: state.selectedTransporter,
          hint: const Text('Assigner un transporteur'),
          isExpanded: true,
          items: ['LOGIS-TRANS', 'AFRI-TRUCK', 'EXPRESS-COFFEE'].map((t) {
            return DropdownMenuItem(
              value: t,
              child: Text(
                t,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
          onChanged: (val) =>
              ref.read(transferNotifierProvider.notifier).setTransporter(val),
        ),
      ),
    );
  }

  Widget _buildDropdownContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: child,
    );
  }

  Widget _buildSummary(TransferFormState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1E17).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryItem('LOTS', '${state.selectedLots.length}'),
          _buildSummaryItem('POIDS TOTAL', '${state.totalWeight} KG'),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF2D1E17),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(WidgetRef ref, TransferFormState state) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: state.isLoading ? null : () => _handleSubmit(ref),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D1E17),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: state.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'LANCER LE TRANSFERT',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }

  void _handleSubmit(WidgetRef ref) async {
    await ref.read(transferNotifierProvider.notifier).submitTransfer();
  }
}
