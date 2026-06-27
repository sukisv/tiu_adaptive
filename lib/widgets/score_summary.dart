import 'package:flutter/material.dart';
import '../app_theme.dart';

class ScoreSummary extends StatelessWidget {
  final int correct;
  final int wrong;
  final int total;

  const ScoreSummary({
    super.key,
    required this.correct,
    required this.wrong,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (correct * 100 ~/ total) : 0;
    final isGood = pct >= 70;
    final color = pct >= 80
        ? AppColors.greenTxt
        : pct >= 60
            ? AppColors.amberTxt
            : AppColors.redTxt;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isGood ? Icons.emoji_events_rounded : Icons.bar_chart_rounded,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Hasil Latihan',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ink),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _StatTile(
                  value: '$pct%',
                  label: 'Skor',
                  color: color,
                  large: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _StatTile(
                              value: '$correct',
                              label: 'Benar',
                              color: AppColors.greenTxt,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _StatTile(
                              value: '$wrong',
                              label: 'Salah',
                              color: AppColors.redTxt,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _StatTile(
                              value: '$total',
                              label: 'Total',
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: total > 0 ? correct / total : 0,
                          minHeight: 8,
                          backgroundColor: AppColors.redBg,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool large;

  const _StatTile({
    required this.value,
    required this.label,
    required this.color,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: large ? 36 : 22,
            fontWeight: FontWeight.w500,
            color: color,
            height: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.muted),
        ),
      ],
    );
  }
}
