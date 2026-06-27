import 'package:flutter/material.dart';

class AppColors {
  static const gold = Color(0xFFC8960C);
  static const goldDark = Color(0xFFA67C00);
  static const ink = Color(0xFF1A1409);
  static const background = Color(0xFFF0F2F5);
  static const surface = Colors.white;
  static const muted = Color(0xFF6B7280);
  static const divider = Color(0xFFE0E0E0);

  static const greenBg = Color(0xFFE8F5E9);
  static const greenBdr = Color(0xFF4CAF50);
  static const greenTxt = Color(0xFF1B5E20);
  static const redBg = Color(0xFFFFEBEE);
  static const redBdr = Color(0xFFEF5350);
  static const redTxt = Color(0xFFB71C1C);
  static const amberBg = Color(0xFFFFF8E1);
  static const amberBdr = Color(0xFFFFB300);
  static const amberTxt = Color(0xFFE65100);
  static const blueBg = Color(0xFFE3F2FD);
  static const blueBdr = Color(0xFF42A5F5);
  static const blueTxt = Color(0xFF0D47A1);
  static const purpleBg = Color(0xFFF3E5F5);
  static const purpleBdr = Color(0xFFAB47BC);
  static const purpleTxt = Color(0xFF4A148C);
  static const purple = Color(0xFF7C4DFF);

  // legacy compat
  static const cream = Color(0xFFFDF8ED);
  static const cream2 = Color(0xFFF7F0D8);
  static const cream3 = Color(0xFFEFE5C2);
  static const gold2 = goldDark;
  static const ink2 = Color(0xFF3B2F0F);
  static const rule = Color(0xFFD4BE82);
  static const rule2 = Color(0xFFC4A84A);
  static const procBg = Color(0xFF1565C0);
  static const procTxt = Color(0xFFAAC4E8);
  static const procBdr = Color(0xFF3A5070);
  static const aqgBg = Color(0xFF6A1B9A);
  static const aqgTxt = Color(0xFFC4A8E8);
  static const aqgBdr = Color(0xFF4A3070);
  static const purpleLight = Color(0xFFF5EEFA);
}

class AppTextStyles {
  static TextStyle labelSmall({
    Color color = AppColors.muted,
    FontWeight weight = FontWeight.w400,
    double size = 11,
    double letterSpacing = 0.3,
  }) =>
      TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );

  static TextStyle body({
    double size = 15,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double height = 1.6,
  }) =>
      TextStyle(fontSize: size, fontWeight: weight, color: color, height: height);

  static TextStyle numDisplay({
    double size = 24,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
  }) =>
      TextStyle(fontSize: size, fontWeight: weight, color: color);

  // legacy shim — used by widgets that haven't been updated
  static TextStyle monoStyle({
    double size = 12,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double letterSpacing = 0,
  }) =>
      TextStyle(fontSize: size, fontWeight: weight, color: color, letterSpacing: letterSpacing);

  static TextStyle serifStyle({
    double size = 15,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
  }) =>
      TextStyle(fontSize: size, fontWeight: weight, color: color, height: 1.65);

  static TextStyle displayStyle({
    double size = 24,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
  }) =>
      TextStyle(fontSize: size, fontWeight: weight, color: color);
}
