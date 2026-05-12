import 'package:flutter/material.dart';
import '../../domain/entities/parcelle.dart';
import 'package:intl/intl.dart';

class ParcelleCard extends StatelessWidget {
  final Parcelle parcelle;
  final VoidCallback? onTap;

  const ParcelleCard({super.key, required this.parcelle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              // Abstract organic shape in corner
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[800]!.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.green[800]!.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'CERTIFIÉ CACAO',
                                style: TextStyle(
                                  color: Colors.green[400],
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yy').format(parcelle.createdAt),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      parcelle.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.person_rounded,
                          size: 14,
                          color: Colors.brown[300],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          parcelle.ownerName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.brown[100],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetric(
                            'SURFACE',
                            '${parcelle.area.toStringAsFixed(2)} ha',
                            Icons.layers_outlined,
                          ),
                        ),
                        Container(width: 1, height: 30, color: Colors.white10),
                        Expanded(
                          child: _buildMetric(
                            'GÉOMÉTRIE',
                            '${parcelle.polygon.length} Points',
                            Icons.polyline_outlined,
                          ),
                        ),
                      ],
                    ),
                    if (parcelle.description != null &&
                        parcelle.description!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        parcelle.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.green[400]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey[500],
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
