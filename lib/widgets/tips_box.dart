import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/tip_item.dart';
import '../services/service_locator.dart';
import 'math_text.dart';

class TipsBox extends StatelessWidget {
  final String category;
  final String difficulty;

  const TipsBox({super.key, required this.category, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final tipsService = serviceLocator.tipsService;
    final tips = tipsService.tipsMap[category] ?? tipsService.tipsMap['mixed']!;
    final cat = tipsService.categoryLabels[category] ?? category;
    final diff = tipsService.difficultyLabels[difficulty] ?? difficulty;

    return Card(
      color: AppColors.amberBg,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.amberBdr.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.tips_and_updates_rounded, color: AppColors.amberTxt, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tips Menjawab Cepat — $cat · $diff',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.amberTxt,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...tips.map((tip) => _TipItem(tip)),
          ],
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final TipItem tip;
  const _TipItem(this.tip);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              tip.num,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: MathText(
              tip.text,
              style: const TextStyle(fontSize: 13, color: AppColors.amberTxt, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
