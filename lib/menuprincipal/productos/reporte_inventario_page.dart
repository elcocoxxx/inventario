import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReporteInventarioPage extends StatelessWidget {
  ReporteInventarioPage({super.key});

  final formatoCOP =
      NumberFormat.currency(locale: 'es_CO', symbol: '\$ ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        title: const Text(
          'Reporte por Categoría',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('productos').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          final Map<String, Map<String, num>> reporte = {};

          for (var p in docs) {
            final categoria = p['categoria'];
            final stock = p['stock'];
            final valor = p['valorUnitario'];

            reporte.putIfAbsent(categoria, () {
              return {
                'productos': 0,
                'stock': 0,
                'total': 0,
              };
            });

            reporte[categoria]!['productos'] =
                reporte[categoria]!['productos']! + 1;
            reporte[categoria]!['stock'] =
                reporte[categoria]!['stock']! + stock;
            reporte[categoria]!['total'] =
                reporte[categoria]!['total']! + (stock * valor);
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: reporte.entries.map((e) {
              return Card(
                color: const Color(0xFF1E1E1E),
                child: ListTile(
                  title: Text(
                    e.key,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Productos: ${e.value['productos']} | '
                    'Stock: ${e.value['stock']} | '
                    'Total: ${formatoCOP.format(e.value['total'])}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
