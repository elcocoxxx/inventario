import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CajaBarberoPage extends StatelessWidget {
  const CajaBarberoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hoy = DateTime.now();
    final inicioDia = DateTime(hoy.year, hoy.month, hoy.day);
    final finDia = inicioDia.add(const Duration(days: 1));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(

      backgroundColor: const Color(0xFF1F1F1F),
        elevation: 4,

        // 👈 Flecha de retroceso en BLANCO
        iconTheme: const IconThemeData(color: Colors.white),

        title: const Text(
          'Servicios',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cortes')
            .where(
              'fecha',
              isGreaterThanOrEqualTo: Timestamp.fromDate(inicioDia),
            )
            .where(
              'fecha',
              isLessThan: Timestamp.fromDate(finDia),
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cortes = snapshot.data!.docs;

          if (cortes.isEmpty) {
            return const Center(
              child: Text(
                'No hay ventas hoy',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          // 🔥 Agrupar por barbero
          final Map<String, double> totalPorBarbero = {};
          final Map<String, int> cortesPorBarbero = {};

          for (var c in cortes) {
            final nombre = c['barberoNombre'];
            final valor = (c['valor'] as num).toDouble();

            totalPorBarbero[nombre] =
                (totalPorBarbero[nombre] ?? 0) + valor;

            cortesPorBarbero[nombre] =
                (cortesPorBarbero[nombre] ?? 0) + 1;
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: totalPorBarbero.keys.map((barbero) {
              return Card(
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  title: Text(
                    barbero,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Cortes: ${cortesPorBarbero[barbero]}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    NumberFormat.currency(
                      locale: 'es',
                      symbol: '\$',
                    ).format(totalPorBarbero[barbero]),
                    style: const TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
