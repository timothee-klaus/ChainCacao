import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:ui' as ui;
import '../../domain/entities/parcelle.dart';

class ParcelleMapPage extends StatefulWidget {
  final Parcelle parcelle;

  const ParcelleMapPage({super.key, required this.parcelle});

  @override
  State<ParcelleMapPage> createState() => _ParcelleMapPageState();
}

class _ParcelleMapPageState extends State<ParcelleMapPage> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final points = widget.parcelle.polygon
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    // Calculate bounds to center the map
    LatLng center = const LatLng(0, 0);
    if (points.isNotEmpty) {
      double lat = 0;
      double lon = 0;
      for (var p in points) {
        lat += p.latitude;
        lon += p.longitude;
      }
      center = LatLng(lat / points.length, lon / points.length);
    }

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
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          child: Text(
            widget.parcelle.name.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(initialCenter: center, initialZoom: 18.0),
            children: [
              TileLayer(
                urlTemplate:
                    'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}',
                userAgentPackageName: 'com.chaincacao.app',
              ),
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: points,
                    color: Colors.green.withValues(alpha: 0.3),
                    borderColor: Colors.green,
                    borderStrokeWidth: 3,
                  ),
                ],
              ),
              MarkerLayer(
                markers: points
                    .map(
                      (p) => Marker(
                        point: p,
                        width: 8,
                        height: 8,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),

          // Info Overlay
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 40,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Header / Compact View
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.parcelle.name.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1A1A1A),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.verified,
                                          size: 12,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'PARCELLE CERTIFIÉE',
                                          style: TextStyle(
                                            color: Colors.green[800],
                                            fontSize: 9,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Color(0xFF1A1A1A),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isExpanded
                                    ? Icons.close_rounded
                                    : Icons.info_outline_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),

                        // Dashboard Tiles (Expanded)
                        if (_isExpanded) ...[
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              _buildDashboardTile(
                                Icons.square_foot_rounded,
                                'SURFACE',
                                '${widget.parcelle.area.toStringAsFixed(2)} ha',
                                Colors.brown[50]!,
                                Colors.brown[700]!,
                              ),
                              const SizedBox(width: 16),
                              _buildDashboardTile(
                                Icons.gps_fixed_rounded,
                                'PRÉCISION',
                                '${widget.parcelle.polygon.length} Points',
                                Colors.blue[50]!,
                                Colors.blue[700]!,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDashboardTile(
                            Icons.calendar_today_rounded,
                            'DATE D\'ENREGISTREMENT',
                            '${widget.parcelle.createdAt.day} / ${widget.parcelle.createdAt.month} / ${widget.parcelle.createdAt.year}',
                            Colors.grey[50]!,
                            Colors.grey[800]!,
                            isFullWidth: true,
                          ),
                          if (widget.parcelle.description != null &&
                              widget.parcelle.description!.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.black.withValues(alpha: 0.05),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NOTES',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey[400],
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.parcelle.description!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[800],
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTile(
    IconData icon,
    String label,
    String value,
    Color bgColor,
    Color iconColor, {
    bool isFullWidth = false,
  }) {
    return Expanded(
      flex: isFullWidth ? 0 : 1,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: Colors.grey[500],
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
