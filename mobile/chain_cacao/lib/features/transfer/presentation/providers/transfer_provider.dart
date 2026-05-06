import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:isar/isar.dart';
import '../../data/models/transfer_model.dart';
import '../../../cacao_lot/domain/entities/cacao_lot.dart';
import '../../../cacao_lot/data/models/cacao_lot_model.dart';
import '../../../../core/database/isar_service.dart';
import '../../../../core/database/queue_item.dart';
import '../../../cacao_lot/presentation/providers/cacao_lot_list_provider.dart';

class TransferFormState {
  final List<CacaoLot> selectedLots;
  final String? selectedCoop;
  final String? selectedTransporter;
  final bool isLoading;
  final String? error;
  final bool success;

  TransferFormState({
    this.selectedLots = const [],
    this.selectedCoop,
    this.selectedTransporter,
    this.isLoading = false,
    this.error,
    this.success = false,
  });

  double get totalWeight => selectedLots.fold(0, (sum, lot) => sum + lot.weightKg);

  TransferFormState copyWith({
    List<CacaoLot>? selectedLots,
    String? selectedCoop,
    String? selectedTransporter,
    bool? isLoading,
    String? error,
    bool? success,
  }) {
    return TransferFormState(
      selectedLots: selectedLots ?? this.selectedLots,
      selectedCoop: selectedCoop ?? this.selectedCoop,
      selectedTransporter: selectedTransporter ?? this.selectedTransporter,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success ?? this.success,
    );
  }
}

class TransferNotifier extends StateNotifier<TransferFormState> {
  final Ref _ref;
  final IsarService _isarService;

  TransferNotifier(this._ref, this._isarService) : super(TransferFormState());

  void toggleLot(CacaoLot lot) {
    final isSelected = state.selectedLots.any((l) => l.lotId == lot.lotId);
    if (isSelected) {
      state = state.copyWith(
        selectedLots: state.selectedLots.where((l) => l.lotId != lot.lotId).toList(),
      );
    } else {
      state = state.copyWith(
        selectedLots: [...state.selectedLots, lot],
      );
    }
  }

  void setCoop(String? coop) => state = state.copyWith(selectedCoop: coop);
  void setTransporter(String? transporter) => state = state.copyWith(selectedTransporter: transporter);

  Future<void> submitTransfer() async {
    if (state.selectedLots.isEmpty || state.selectedCoop == null || state.selectedTransporter == null) {
      state = state.copyWith(error: 'Veuillez remplir tous les champs');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final isar = await _isarService.db;
      final transferId = const Uuid().v4();
      final orderId = const Uuid().v4();

      await isar.writeTxn(() async {
        // 1. Création du Transfert
        final transfer = TransferModel()
          ..transferId = transferId
          ..lotIds = state.selectedLots.map((l) => l.lotId).toList()
          ..expediteurNom = 'Agriculteur' // Idéalement depuis authProvider
          ..destinataireNom = state.selectedCoop!
          ..syncStatus = 'pending'
          ..createdAt = DateTime.now();
        
        await isar.collection<TransferModel>().put(transfer);

        // 2. Création de l'Ordre de Transport
        final order = TransportOrderModel()
          ..orderId = orderId
          ..transferId = transferId
          ..transporterId = state.selectedTransporter!
          ..lieuPickup = 'Ferme Agriculteur'
          ..lieuDropoff = state.selectedCoop!
          ..datePickup = DateTime.now()
          ..statut = 'assigne';

        await isar.collection<TransportOrderModel>().put(order);

        // 3. Mise à jour du statut des lots
        for (final lotEntity in state.selectedLots) {
          final lotModel = await isar.collection<CacaoLotModel>()
              .filter()
              .lotIdEqualTo(lotEntity.lotId)
              .findFirst();
          
          if (lotModel != null) {
            lotModel.statut = 'transferred';
            lotModel.updatedAt = DateTime.now();
            await isar.collection<CacaoLotModel>().put(lotModel);
          }
        }

        // 4. Ajout à la file d'attente de synchro
        final queueItem = QueueItem()
          ..queueId = const Uuid().v4()
          ..payloadType = 'transfer'
          ..payloadRef = transferId
          ..tentatives = 0
          ..statut = 'pending'
          ..dateCreation = DateTime.now();
        
        await isar.collection<QueueItem>().put(queueItem);
      });
      
      // Simulation d'un délai réseau pour l'UI
      await Future.delayed(const Duration(seconds: 1));
      
      // Rafraîchir les listes
      _ref.invalidate(cacaoLotListNotifierProvider);
      
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void reset() {
    state = TransferFormState();
  }
}

final transferNotifierProvider = StateNotifierProvider.autoDispose<TransferNotifier, TransferFormState>((ref) {
  final isarService = ref.read(isarServiceProvider);
  return TransferNotifier(ref, isarService);
});
