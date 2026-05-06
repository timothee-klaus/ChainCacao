import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cacao_lot_form_provider.dart';

class LotPhotoSelector extends ConsumerWidget {
  const LotPhotoSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(cacaoLotFormNotifierProvider).photos;
    final controller = ref.read(cacaoLotFormNotifierProvider.notifier);

    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.brown[50]!.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.brown[100]!, width: 2),
      ),
      child: InkWell(
        onTap: controller.takePhoto,
        borderRadius: BorderRadius.circular(24),
        child: photos.isEmpty 
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_enhance_outlined, size: 40, color: Colors.brown[300]),
                const SizedBox(height: 8),
                Text('Prendre une photo du lot', style: TextStyle(color: Colors.brown[400], fontWeight: FontWeight.bold)),
              ],
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              itemCount: photos.length + 1,
              itemBuilder: (context, index) {
                if (index == photos.length) {
                  return IconButton(
                    icon: const Icon(Icons.add_a_photo, color: Colors.brown),
                    onPressed: controller.takePhoto,
                  );
                }
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: FileImage(File(photos[index])),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 12,
                        child: Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                      onPressed: () => controller.removePhoto(index),
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}
