import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import '../../domain/entities/cacao_lot.dart';
import '../../../../core/services/share/share_service.dart';

class LotDetailQRCode extends StatefulWidget {
  final CacaoLot lot;

  const LotDetailQRCode({super.key, required this.lot});

  @override
  State<LotDetailQRCode> createState() => _LotDetailQRCodeState();
}

class _LotDetailQRCodeState extends State<LotDetailQRCode> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final ShareService _shareService = ShareService();
  bool _isExporting = false;

  Future<void> _exportQRCode() async {
    setState(() => _isExporting = true);
    try {
      final image = await _screenshotController.capture();
      if (image != null) {
        await _shareService.shareLotWithQR(
          lot: widget.lot,
          qrImageBytes: image,
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          
          // Screenshot target
          Screenshot(
            controller: _screenshotController,
            child: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                children: [
                  const Text(
                    'CERTIFICAT DE TRAÇABILITÉ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  QrImageView(
                    data: widget.lot.lotId,
                    version: QrVersions.auto,
                    size: 200.0,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Color(0xFF2D1E17),
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Color(0xFF2D1E17),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ID: ${widget.lot.lotId.toUpperCase()}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 8,
                      fontFamily: 'Courier',
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _isExporting ? null : _exportQRCode,
              icon: _isExporting 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.share_outlined),
              label: const Text('Partager le Passeport', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D1E17),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
