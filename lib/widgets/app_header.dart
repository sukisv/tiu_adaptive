import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app_theme.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.ink,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: [
          SvgPicture.asset('assets/icon.svg', width: 44, height: 44),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TIU Adaptive', style: AppTextStyles.displayStyle(size: 22, color: AppColors.cream)),
                const SizedBox(height: 4),
                Text(
                  'TES INTELEGENSI UMUM — PROCEDURAL GENERATION & AQG',
                  style: AppTextStyles.monoStyle(
                    size: 9,
                    color: Colors.white.withValues(alpha: 0.38),
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Badge('⚙ PROCGEN', AppColors.procBg, AppColors.procTxt, AppColors.procBdr),
                    const SizedBox(width: 8),
                    _Badge('✦ AQG · AI', AppColors.aqgBg, AppColors.aqgTxt, AppColors.aqgBdr),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color bg, txt, bdr;
  const _Badge(this.label, this.bg, this.txt, this.bdr);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: bdr),
      ),
      child: Text(
        label,
        style: AppTextStyles.monoStyle(size: 9, weight: FontWeight.w600, color: txt, letterSpacing: 0.1),
      ),
    );
  }
}
