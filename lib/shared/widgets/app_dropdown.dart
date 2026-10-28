import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppDropdown extends StatelessWidget {

  final String value;

  final List<String> items;

  final ValueChanged<String?> onChanged;

  const AppDropdown({

    super.key,

    required this.value,

    required this.items,

    required this.onChanged,

  });

  @override

  Widget build(BuildContext context) {

    return DropdownButtonFormField<String>(

      value: value,

      dropdownColor: AppColors.card,

      decoration: InputDecoration(

        filled: true,

        fillColor: AppColors.card,

        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(14),

        ),

      ),

      style: const TextStyle(

        color: Colors.white,

      ),

      items: items

          .map(

            (e) => DropdownMenuItem(

              value: e,

              child: Text(e),

            ),

          )

          .toList(),

      onChanged: onChanged,

    );

  }

}