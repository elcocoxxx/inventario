import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppTextField extends StatelessWidget {

  final TextEditingController controller;

  final String label;

  final TextInputType keyboardType;

  const AppTextField({

    super.key,

    required this.controller,

    required this.label,

    this.keyboardType = TextInputType.text,

  });

  @override

  Widget build(BuildContext context) {

    return TextField(

      controller: controller,

      keyboardType: keyboardType,

      style: const TextStyle(

        color: Colors.white,

      ),

      decoration: InputDecoration(

        labelText: label,

        filled: true,

        fillColor: AppColors.card,

        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(14),

        ),

      ),

    );

  }

}