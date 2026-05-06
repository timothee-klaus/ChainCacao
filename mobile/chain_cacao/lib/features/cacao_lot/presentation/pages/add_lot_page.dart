import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/cacao_lot.dart';
import '../controllers/cacao_lot_form_controller.dart';
import '../widgets/lot_photo_selector.dart';
import '../widgets/lot_location_card.dart';
import 'lot_success_page.dart';

class AddLotPage extends ConsumerStatefulWidget {
  const AddLotPage({super.key});

  @override
  ConsumerState<AddLotPage> createState() => _AddCacaoLotPageState();
}

class _AddCacaoLotPageState extends ConsumerState<AddLotPage> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _varietyController = TextEditingController();

  String _selectedSpecies = 'Cacao';
  String _selectedRegion = 'Plateaux';

  final List<String> _species = ['Cacao', 'Café'];
  final List<String> _regions = [
    'Plateaux',
    'Centrale',
    'Kara',
    'Savanes',
    'Maritime',
  ];

  @override
  void dispose() {
    _weightController.dispose();
    _varietyController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(authProvider).user;
      if (user == null) return;

      final lot = CacaoLot(
        lotId: const Uuid().v4(),
        farmerId: user.userId,
        region: _selectedRegion,
        weightKg: double.parse(_weightController.text),
        species: _selectedSpecies,
        variete: _varietyController.text,
        dateCollecte: DateTime.now(),
        coopName: 'Coopérative Togolaise',
        statut: 'draft',
        syncStatus: 'pending',
        createdBy: user.userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      ref.read(cacaoLotFormControllerProvider.notifier).submitLot(lot);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cacaoLotFormControllerProvider);

    ref.listen(cacaoLotFormControllerProvider, (previous, next) {
      if (next.success && next.savedLot != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LotSuccessPage(lot: next.savedLot!),
          ),
        );
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'ENREGISTRER UNE RÉCOLTE',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.brown[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Widget modulaire pour les photos
            const LotPhotoSelector(),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Widget modulaire pour la localisation
                    const LotLocationCard(),

                    const SizedBox(height: 32),
                    _buildSectionTitle('Détails techniques'),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedSpecies,
                            decoration: _buildInputDecoration(
                              'Espèce',
                              Icons.eco_outlined,
                            ),
                            items: _species
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) =>
                                setState(() => _selectedSpecies = value!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _varietyController,
                            decoration: _buildInputDecoration(
                              'Variété',
                              Icons.category_outlined,
                            ),
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? 'Requis'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      decoration: _buildInputDecoration(
                        'Poids total (Kg)',
                        Icons.scale_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Champ obligatoire';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Nombre invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      initialValue: _selectedRegion,
                      decoration: _buildInputDecoration(
                        'Région de collecte',
                        Icons.map_outlined,
                      ),
                      items: _regions
                          .map(
                            (r) => DropdownMenuItem(value: r, child: Text(r)),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedRegion = value!),
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state.isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[900],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: state.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'CONFIRMER L\'ENREGISTREMENT',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: Colors.brown[300],
        letterSpacing: 1.5,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.brown[800], size: 20),
      labelStyle: TextStyle(color: Colors.brown[400], fontSize: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.brown[50]!.withValues(alpha: 0.5),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }
}
