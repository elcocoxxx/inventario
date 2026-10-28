import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ========= FONDOS =========
  static const Color background = Color(0xFF0F1115);
  static const Color scaffold = Color(0xFF0F1115);
  static const Color card = Color(0xFF181B21);
  static const Color field = Color(0xFF20242C);

  // ========= COLOR PRINCIPAL =========
  static const Color primary = Color(0xFF14B8A6);
  // Texto/icono sobre el color principal (el blanco solo da ~2.5:1 de contraste)
  static const Color onPrimary = Color(0xFF04201D);

  // ========= SECUNDARIO =========
  static const Color secondary = Color(0xFF0EA5E9);

  // ========= ACENTOS (dashboard) =========
  static const Color accentPink = Color(0xFFF472B6);
  static const Color accentAmber = Color(0xFFFBBF24);
  static const Color accentPurple = Color(0xFFA78BFA);

  // ========= TEXTO =========
  static const Color textPrimary = Color(0xFFF3F4F6);
  static const Color textSecondary = Color(0xFF9CA3AF);

  // ========= ESTADOS =========
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFACC15);
  static const Color danger = Color(0xFFEF4444);

  // ========= BORDES =========
  static const Color border = Color(0xFF2A2F3A);

  // ========= SOMBRAS =========
  static const Color shadow = Colors.black54;

  /// Versión translúcida de un color (para fondos de iconos/chips).
  static Color soft(Color c, [int alpha = 36]) => c.withAlpha(alpha);
}
