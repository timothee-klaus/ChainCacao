import 'package:isar/isar.dart';

part 'transfer_model.g.dart';

@Collection()
class TransferModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String transferId;
  
  String? transferHashOnChain;
  
  late List<String> lotIds;
  
  late String expediteurNom;
  late String destinataireNom;
  
  String? preuveDocumentUrl;
  
  late String syncStatus; // synced / pending / error
  
  late DateTime createdAt;
  
  List<String>? signedBy;
}

@Collection()
class TransportOrderModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String orderId;
  
  late String transferId;
  
  late String transporterId;
  
  String? vehicleId;
  String? driverId;
  
  late String lieuPickup;
  late String lieuDropoff;
  
  late DateTime datePickup;
  DateTime? eta;
  
  late String statut; // assigne / picked_up / in_transit / delivered / cancelled
}
