import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../providers/parcelle_provider.dart';

class AddParcellePage extends ConsumerStatefulWidget {
  const AddParcellePage({super.key});

  @override
  ConsumerState<AddParcellePage> createState() => _AddParcellePageState();
}

class _AddParcellePageState extends ConsumerState<AddParcellePage> {
  final MapController _mapController = MapController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ownerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isSatellite = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final position = await Geolocator.getCurrentPosition();
    if (mounted) {
      _mapController.move(LatLng(position.latitude, position.longitude), 17.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(parcelleNotifierProvider);
    final notifier = ref.read(parcelleNotifierProvider.notifier);

    // Convert recorded path to LatLng for the map
    final polylinePoints = state.recordedPath
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: state.currentLocation != null
                  ? LatLng(
                      state.currentLocation!.latitude,
                      state.currentLocation!.longitude,
                    )
                  : const LatLng(0, 0),
              initialZoom: 17.0,
            ),
            children: [
              TileLayer(
                urlTemplate: _isSatellite
                    ? 'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.chaincacao.app',
              ),
              if (polylinePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: polylinePoints,
                      color: Colors.green,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),
              if (polylinePoints.length >= 3)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: polylinePoints,
                      color: Colors.green.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (state.currentLocation != null)
                    Marker(
                      point: LatLng(
                        state.currentLocation!.latitude,
                        state.currentLocation!.longitude,
                      ),
                      width: 60,
                      height: 60,
                      child: _buildUserLocationMarker(state.heading),
                    ),
                ],
              ),
            ],
          ),

          // Map Type Toggle
          Positioned(
            top: 100,
            right: 20,
            child: Column(
              children: [
                _buildMapControl(
                  icon: _isSatellite
                      ? Icons.layers_outlined
                      : Icons.satellite_alt_outlined,
                  onTap: () => setState(() => _isSatellite = !_isSatellite),
                  label: _isSatellite ? 'PLAN' : 'SAT',
                ),
              ],
            ),
          ),

          // UI Overlay
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.isRecording)
                  _buildRecordingStats(state.recordedPath.length),
                const SizedBox(height: 16),
                _buildActionButtons(state.isRecording, notifier),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingStats(int pointsCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'ENREGISTREMENT EN COURS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$pointsCount PTS',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isRecording, ParcelleNotifier notifier) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: isRecording
                ? () => _showSaveDialog(notifier)
                : () => notifier.startRecording(),
            style: ElevatedButton.styleFrom(
              backgroundColor: isRecording
                  ? Colors.green[700]
                  : const Color(0xFF1A1A1A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
            ),
            child: Text(
              isRecording
                  ? 'TERMINER ET ENREGISTRER'
                  : 'LANCER L\'ENREGISTREMENT',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSaveDialog(ParcelleNotifier notifier) {
    notifier.stopRecording();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          top: 16,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.brown[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    color: Colors.brown[900],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'DÉTAILS DE LA PARCELLE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: _inputDecoration(
                'Nom de la parcelle',
                Icons.landscape_rounded,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ownerController,
              decoration: _inputDecoration(
                'Propriétaire',
                Icons.person_rounded,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: _inputDecoration(
                'Notes additionnelles (optionnel)',
                Icons.notes_rounded,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  notifier.saveParcelle(
                    _nameController.text,
                    _ownerController.text,
                    _descriptionController.text,
                  );
                  Navigator.pop(context); // Close sheet
                  Navigator.pop(context); // Go back to list
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'CONFIRMER L\'ENREGISTREMENT',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.grey[500],
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: Icon(icon, color: Colors.brown[300], size: 20),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 1.5),
      ),
    );
  }

  Widget _buildMapControl({
    required IconData icon,
    required VoidCallback onTap,
    required String label,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF1A1A1A), size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserLocationMarker(double? heading) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (heading != null)
          Transform.rotate(
            angle: heading * (math.pi / 180),
            child: CustomPaint(
              size: const Size(60, 60),
              painter: DirectionConePainter(),
            ),
          ),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DirectionConePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF2196F3).withValues(alpha: 0.3),
          const Color(0xFF2196F3).withValues(alpha: 0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = ui.Path()
      ..moveTo(size.width / 2, size.height / 2)
      ..relativeLineTo(-size.width / 4, -size.height / 2)
      ..arcToPoint(
        Offset(size.width * 0.75, 0),
        radius: Radius.circular(size.width / 2),
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
