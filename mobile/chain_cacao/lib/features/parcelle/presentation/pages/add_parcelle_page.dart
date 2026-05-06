import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
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

  LatLng? _currentLocation;
  bool _isSatellite = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_currentLocation!, 17.0);
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
              initialCenter: _currentLocation ?? const LatLng(0, 0),
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
                  if (_currentLocation != null)
                    Marker(
                      point: _currentLocation!,
                      width: 20,
                      height: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
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
                  icon: _isSatellite ? Icons.layers_outlined : Icons.satellite_alt_outlined,
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.radio_button_checked, color: Colors.red, size: 16),
          const SizedBox(width: 8),
          Text(
            'ENREGISTREMENT... ($pointsCount points)',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 0.5,
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
              backgroundColor: isRecording ? Colors.green[700] : const Color(0xFF1A1A1A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
            ),
            child: Text(
              isRecording ? 'TERMINER ET ENREGISTRER' : 'LANCER L\'ENREGISTREMENT',
              style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          top: 32,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DÉTAILS DE LA PARCELLE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: _inputDecoration('Nom de la parcelle', Icons.landscape_outlined),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ownerController,
              decoration: _inputDecoration('Propriétaire', Icons.person_outline),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: _inputDecoration('Notes additionnelles (optionnel)', Icons.note_add_outlined),
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
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'CONFIRMER L\'ENREGISTREMENT',
                  style: TextStyle(fontWeight: FontWeight.w900),
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
      prefixIcon: Icon(icon, color: Colors.brown[300]),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildMapControl({required IconData icon, required VoidCallback onTap, required String label}) {
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
}
