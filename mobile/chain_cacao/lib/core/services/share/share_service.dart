import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../features/cacao_lot/domain/entities/cacao_lot.dart';

class ShareService {
  Future<void> shareLotWithQR({
    required CacaoLot lot,
    required Uint8List qrImageBytes,
    String? producerName,
  }) async {
    final dateStr = DateFormat('dd/MM/yyyy').format(lot.dateCollecte);
    final lotRef = lot.lotId.length > 8
        ? lot.lotId.substring(0, 8).toUpperCase()
        : lot.lotId.toUpperCase();

    final text = _buildShareText(lot, lotRef, dateStr, producerName);

    final directory = await getTemporaryDirectory();
    final fileName = 'QR_LOT_$lotRef.png';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(qrImageBytes);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: text,
        subject: 'Code QR - Lot $lotRef',
      ),
    );
  }

  Future<void> shareLotInfo(
    CacaoLot lot, {
    String? producerName,
    bool includeQR = false,
  }) async {
    final dateStr = DateFormat('dd/MM/yyyy').format(lot.dateCollecte);
    final lotRef = lot.lotId.length > 8
        ? lot.lotId.substring(0, 8).toUpperCase()
        : lot.lotId.toUpperCase();

    final text = _buildShareText(lot, lotRef, dateStr, producerName);

    if (includeQR) {
      final qrBytes = await generateQRCode(lot.lotId);
      await shareLotWithQR(
        lot: lot,
        qrImageBytes: qrBytes,
        producerName: producerName,
      );
    } else {
      await SharePlus.instance.share(
        ShareParams(text: text, subject: 'Passeport Cacao - Lot $lotRef'),
      );
    }
  }

  String _buildShareText(
    CacaoLot lot,
    String lotRef,
    String dateStr,
    String? producerName,
  ) {
    return '''
**LOT PARTAGÉ AVEC CODE QR**
**ChainCacao - Système de Traçabilité Immuable**

-------------------------------

RÉFÉRENCE UNIQUE : $lotRef
👤 PRODUCTEUR : ${producerName ?? lot.farmerId}
🌿 VARIÉTÉ : ${lot.variete.isEmpty ? "Non spécifiée" : lot.variete}
⚖️ POIDS NET : ${lot.weightKg} KG
📅 RÉCOLTE LE : $dateStr
🌲 CONFORMITÉ EUDR : CERTIFIÉ
(Zéro Déforestation - Coordonnées GPS vérifiées)

🔐 INTÉGRITÉ : Ce lot est sécurisé par un identifiant unique et enregistré pour la synchronisation Blockchain.

🔍 VÉRIFIER LE LOT :
https://chain-cacao.tg/trace/${lot.lotId}

Propulsé par la technologie ChainCacao - MIABE HACKATHON 2026.''';
  }

  Future<Uint8List> generateQRCode(String data) async {
    const double size = 512.0;
    const double padding = 64.0;
    const double qrSize = size - (padding * 2);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(Offset.zero, const Offset(size, size)),
    );

    // 1. Fond Blanc (évite la transparence bizarre)
    final paint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size, size), paint);

    // 2. Bordure élégante
    final borderPaint = Paint()
      ..color = const Color(0xFF2D1E17).withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20, 20, size - 40, size - 40),
        const Radius.circular(32),
      ),
      borderPaint,
    );

    // 3. QR Code
    final painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Color(0xFF2D1E17),
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Color(0xFF2D1E17),
      ),
    );

    canvas.save();
    canvas.translate(
      padding,
      padding - 20,
    ); // Décalé vers le haut pour laisser place au texte
    painter.paint(canvas, Size(qrSize, qrSize));
    canvas.restore();

    // 4. Texte de pied de page (Branding)
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '⛓️ CHAIN CACAO - CODE QR DU LOT CERTIFIÉ',
        style: TextStyle(
          color: Color(0xFF2D1E17),
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size - textPainter.width) / 2, size - padding),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
