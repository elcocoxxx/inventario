import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.primary;
    // Texto oscuro sobre el color principal (mejor contraste); blanco sobre otros.
    final fg = color == null ? AppColors.onPrimary : Colors.white;

    final style = ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
    );

    if (icon == null) {
      return ElevatedButton(onPressed: onPressed, style: style, child: Text(text));
    }
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: style,
      icon: Icon(icon, size: 20),
      label: Text(text),
    );
  }
}
