import 'package:flutter/material.dart';

class FacturasPage extends StatelessWidget {
  const FacturasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facturación'),
      ),
      body: const Center(
        child: Text(
          'Aquí irá la creación de facturas',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
