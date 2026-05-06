import 'package:isar/isar.dart';

part 'queue_item.g.dart';

@collection
class QueueItem {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String queueId = '';

  String payloadType = ''; // create_lot, transfer, etc.
  String payloadRef = ''; // Référence à l'identifiant de l'objet (ex: lotId)
  List<String> mediaRefs = [];
  
  int tentatives = 0;
  
  @Index()
  String statut = 'pending'; // pending, failed, sent
  
  DateTime dateCreation = DateTime.now();

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
