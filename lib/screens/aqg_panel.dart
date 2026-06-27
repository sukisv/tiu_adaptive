import 'package:flutter/material.dart';
import '../app_theme.dart';

class AqgPanel extends StatelessWidget {
  const AqgPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Info card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.purpleBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.psychology_outlined, color: AppColors.purpleTxt, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Question Generation',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.purpleTxt,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Soal dibuat oleh AI (Claude) secara real-time berdasarkan topik yang kamu tentukan. '
                        'Menghasilkan soal naratif, analogi, dan penalaran kompleks — jauh lebih fleksibel dari template statis.',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Disabled notice
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.purpleBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_outline_rounded, size: 36, color: AppColors.purple),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Fitur Belum Aktif',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.ink),
                ),
                const SizedBox(height: 8),
                Text(
                  'AI Question Generation membutuhkan API key Claude.\nFitur ini belum diaktifkan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey[500], height: 1.6),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.key_rounded, size: 16),
                  label: const Text('Konfigurasi API Key'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
