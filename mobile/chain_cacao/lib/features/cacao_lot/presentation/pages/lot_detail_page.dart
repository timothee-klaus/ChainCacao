import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/cacao_lot.dart';
import '../widgets/lot_detail_qr_code.dart';
import '../../../../core/services/share/share_service.dart';

class LotDetailPage extends StatefulWidget {
  final CacaoLot lot;

  const LotDetailPage({super.key, required this.lot});

  @override
  State<LotDetailPage> createState() => _LotDetailPageState();
}

class _LotDetailPageState extends State<LotDetailPage> {
  final PageController _pageController = PageController();
  final ShareService _shareService = ShareService();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'LOT-${widget.lot.lotId.length > 8 ? widget.lot.lotId.substring(0, 8).toUpperCase() : widget.lot.lotId.toUpperCase()}',
          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=farmer'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Gallery Section (Multi-images)
            _buildHeroGallery(),
            
            // Floating Content
            Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainInfoCard(context),
                    const SizedBox(height: 32),
                    _buildHistorySection(),
                    const SizedBox(height: 40),
                    _buildActionButtons(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroGallery() {
    final photos = widget.lot.photoUrls;
    
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 280,
          width: double.infinity,
          child: photos.isNotEmpty 
            ? PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: photos.length,
                itemBuilder: (context, index) => Image.file(
                  File(photos[index]),
                  fit: BoxFit.cover,
                ),
              )
            : Image.network(
                'https://images.unsplash.com/photo-1582131503261-fca1d1c058d3?q=80&w=1000&auto=format&fit=crop',
                fit: BoxFit.cover,
              ),
        ),
        // Page Indicator
        if (photos.length > 1)
          Positioned(
            bottom: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                photos.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.white : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMainInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PRODUIT DE L\'ESTATE',
                    style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.lot.species,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A)),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _shareService.shareLotInfo(widget.lot, includeQR: true),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share_outlined, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildSmallInfoCard(
                  Icons.scale_outlined,
                  'POIDS',
                  '${widget.lot.weightKg} KG',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSmallInfoCard(
                  Icons.calendar_month_outlined,
                  'RÉCOLTE',
                  DateFormat('dd MMM. yyyy').format(widget.lot.dateCollecte),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSmallInfoCard(
            Icons.category_outlined,
            'VARIÉTÉ',
            widget.lot.variete.isEmpty ? "Non spécifiée" : widget.lot.variete,
          ),
          const SizedBox(height: 16),
          _buildLocationWideCard(),
        ],
      ),
    );
  }

  Widget _buildSmallInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.brown[700], size: 20),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildLocationWideCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, color: Colors.brown[700], size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('LOCALISATION', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Région des ${widget.lot.region}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=200&auto=format&fit=crop'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historique du Lot',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A)),
        ),
        const SizedBox(height: 24),
        _buildTimelineItem(
          'En attente de synchronisation',
          'Le lot a été enregistré et attend sa validation sur la blockchain.',
          'AUJOURD\'HUI · ${DateFormat('HH:mm').format(widget.lot.createdAt)}',
          isFirst: true,
          isActive: true,
        ),
        _buildTimelineItem(
          'Récolte terminée',
          'Pesée finale effectuée sur le site de l\'estate.',
          DateFormat('dd MMM. yyyy · HH:mm').format(widget.lot.dateCollecte),
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTimelineItem(String title, String description, String date, {bool isFirst = false, bool isLast = false, bool isActive = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isActive ? Colors.brown[900] : Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 80,
                color: Colors.grey[200],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              const SizedBox(height: 4),
              Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 12, height: 1.4)),
              const SizedBox(height: 8),
              Text(
                date.toUpperCase(),
                style: TextStyle(color: isActive ? Colors.brown[700] : Colors.grey, fontSize: 10, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.sell_outlined),
            label: const Text('Vendre le lot', style: TextStyle(fontWeight: FontWeight.w900)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D1E17),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => LotDetailQRCode(lot: widget.lot),
              );
            },
            icon: const Icon(Icons.qr_code_2),
            label: const Text('Afficher le QR Code', style: TextStyle(fontWeight: FontWeight.w900)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2D1E17),
              side: const BorderSide(color: Color(0xFF2D1E17)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }
}
