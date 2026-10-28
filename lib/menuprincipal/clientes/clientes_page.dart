import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientesPage extends StatelessWidget {
  const ClientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color de fondo general (modo oscuro)
      backgroundColor: const Color(0xFF121212),

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),

        // 🔙 Botón volver en color blanco
        iconTheme: const IconThemeData(color: Colors.white),

        title: const Text(
          'Clientes',
          style: TextStyle(color: Colors.white),
        ),
      ),

      // ================= BOTÓN AGREGAR =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () => _nuevoCliente(context),
      ),

      // ================= LISTA DE CLIENTES =================
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('clientes')
            .orderBy('numeroCliente', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          // Mientras carga la información
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Si no hay datos
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay clientes registrados',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          // Lista de documentos obtenidos de Firestore
          final clientes = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: clientes.length,
            itemBuilder: (_, i) {
              final c = clientes[i];

              return Card(
                color: const Color(0xFF1E1E1E),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  // Número del cliente
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.withOpacity(0.2),
                    child: Text(
                      c['numeroCliente'].toString(),
                      style: const TextStyle(color: Colors.teal),
                    ),
                  ),

                  // Nombre del cliente
                  title: Text(
                    c['nombre'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Teléfono
                  subtitle: Text(
                    c['telefono'],
                    style: const TextStyle(color: Colors.white70),
                  ),

                  // Botón eliminar
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _eliminarCliente(context, c.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ================= CREAR NUEVO CLIENTE =================
  void _nuevoCliente(BuildContext context) async {
    final nombreController = TextEditingController();
    final telefonoController = TextEditingController();

    // 🔢 Obtener el último número de cliente
    final snapshot = await FirebaseFirestore.instance
        .collection('clientes')
        .orderBy('numeroCliente', descending: true)
        .limit(1)
        .get();

    // Si no hay clientes, inicia en 1
    int siguienteNumero = 1;
    if (snapshot.docs.isNotEmpty) {
      siguienteNumero = snapshot.docs.first['numeroCliente'] + 1;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Nuevo Cliente',
          style: TextStyle(color: Colors.white),
        ),

        // Campos del formulario
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: telefonoController,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),

        // Botones del diálogo
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('Guardar'),
            onPressed: () async {
              if (nombreController.text.isEmpty) return;

              // Guardar cliente en Firestore
              await FirebaseFirestore.instance.collection('clientes').add({
                'numeroCliente': siguienteNumero,
                'nombre': nombreController.text,
                'telefono': telefonoController.text,
                'creadoEn': Timestamp.now(),
              });

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ================= ELIMINAR CLIENTE =================
  void _eliminarCliente(BuildContext context, String clienteId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Eliminar cliente',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Estás seguro de eliminar este cliente?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Eliminar'),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('clientes')
                  .doc(clienteId)
                  .delete();

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
