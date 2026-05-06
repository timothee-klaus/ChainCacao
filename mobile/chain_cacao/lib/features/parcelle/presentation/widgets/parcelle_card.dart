import 'package:flutter/material.dart';
import '../../domain/entities/parcelle.dart';
import 'package:intl/intl.dart';

class ParcelleCard extends StatelessWidget {
  final Parcelle parcelle;
  final VoidCallback? onTap;

  const ParcelleCard({
    super.key,
    required this.parcelle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parcelle.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Propriétaire : ${parcelle.ownerName}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${parcelle.area.toStringAsFixed(2)} ha',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfo(Icons.calendar_today_outlined, 
                    DateFormat('dd/MM/yyyy').format(parcelle.createdAt)),
                  const SizedBox(width: 24),
                  _buildInfo(Icons.location_on_outlined, 
                    '${parcelle.polygon.length} points GPS'),
                ],
              ),
              if (parcelle.description != null && parcelle.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  parcelle.description!,
                  maxLines: 2,
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
      ),
    );
  }

  Widget _buildInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.brown[300]),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.brown[700],
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
