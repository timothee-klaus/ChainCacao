import 'package:isar/isar.dart';

part 'queue_item.g.dart';

@collection
class QueueItem {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String queueId;

  late String payloadType; // create_lot, transfer, etc.
  late String payloadRef; // Référence à l'identifiant de l'objet (ex: lotId)
  List<String> mediaRefs = [];
  
  late int tentatives;
  
  @Index()
  late String statut; // pending, failed, sent
  
  late DateTime dateCreation;

  QueueItem();

  factory QueueItem.create({
    required String payloadType,
    required String payloadRef,
    List<String> mediaRefs = const [],
  }) {
    return QueueItem()
      ..queueId = DateTime.now().millisecondsSinceEpoch.toString() // Simple ID pour l'exemple
      ..payloadType = payloadType
      ..payloadRef = payloadRef
      ..mediaRefs = mediaRefs
      ..tentatives = 0
      ..statut = 'pending'
      ..dateCreation = DateTime.now();
  }
}
