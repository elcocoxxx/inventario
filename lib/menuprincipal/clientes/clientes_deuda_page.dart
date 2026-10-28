import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientesDeudaPage extends StatelessWidget {
  const ClientesDeudaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        title: const Text('Clientes con Deuda',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1F1F1F),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ventas')
            .where('pagado', isEqualTo: false)
            .snapshots(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final ventas = snapshot.data!.docs;

          if (ventas.isEmpty) {
            return const Center(
              child: Text(
                'No hay clientes con deuda',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            itemCount: ventas.length,
            itemBuilder: (_, i) {
              final v = ventas[i];
              final fechaPago = v['fechaPago']?.toDate();
              final atrasado = fechaPago != null &&
                  fechaPago.isBefore(DateTime.now());

              return Card(
                color: const Color(0xFF1E1E1E),
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        atrasado ? Colors.red : Colors.orange,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    v['clienteNombre'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Producto: ${v['productoNombre']}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Total: \$${v['total'].toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      if (fechaPago != null)
                        Text(
                          'Pago: ${fechaPago.day}/${fechaPago.month}/${fechaPago.year}',
                          style: TextStyle(
                            color: atrasado
                                ? Colors.redAccent
                                : Colors.white70,
                          ),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.check_circle,
                        color: Colors.green),
                    tooltip: 'Marcar como pagado',
                    onPressed: () {
                      v.reference.update({'pagado': true});
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
