import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  const AppSearchBar({
    super.key,
    required this.controller,
    required this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}