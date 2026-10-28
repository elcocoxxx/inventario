import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // Espacios verticales
  static const SizedBox h4 = SizedBox(height: 4);
  static const SizedBox h8 = SizedBox(height: 8);
  static const SizedBox h12 = SizedBox(height: 12);
  static const SizedBox h16 = SizedBox(height: 16);
  static const SizedBox h20 = SizedBox(height: 20);
  static const SizedBox h24 = SizedBox(height: 24);
  static const SizedBox h32 = SizedBox(height: 32);

  // Espacios horizontales
  static const SizedBox w4 = SizedBox(width: 4);
  static const SizedBox w8 = SizedBox(width: 8);
  static const SizedBox w12 = SizedBox(width: 12);
  static const SizedBox w16 = SizedBox(width: 16);
  static const SizedBox w20 = SizedBox(width: 20);
  static const SizedBox w24 = SizedBox(width: 24);

  // Padding
  static const EdgeInsets screenPadding = EdgeInsets.all(20);

  static const EdgeInsets cardPadding = EdgeInsets.all(16);

  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  );
}