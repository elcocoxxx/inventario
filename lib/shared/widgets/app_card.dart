import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);
    return Material(
      color: AppColors.card,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Ink(
          padding: padding ?? AppSpacing.cardPadding,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: AppColors.border),
          ),
          child: child,
        ),
      ),
    );
  }
}
