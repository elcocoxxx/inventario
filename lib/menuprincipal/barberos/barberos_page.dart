import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarberosPage extends StatelessWidget {
  const BarberosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color de fondo general (modo oscuro)
      backgroundColor: const Color(0xFF121212),

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),

        // 🔙 Icono de volver en color blanco
        iconTheme: const IconThemeData(color: Colors.white),

        // 📌 Título en blanco
        title: const Text(
          'Barberos',
          style: TextStyle(color: Colors.white),
        ),
      ),

      // ================= BOTÓN AGREGAR =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () => _nuevoBarbero(context),
      ),

      // ================= LISTA DE BARBEROS =================
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('barberos')
            .orderBy('creadoEn', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Mientras se cargan los datos
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Si no hay datos
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay barberos registrados',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final barberos = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: barberos.length,
            itemBuilder: (_, i) {
              final b = barberos[i];

              return Card(
                color: const Color(0xFF1E1E1E),
                elevation: 6,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  // Icono del barbero
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, color: Colors.white),
                  ),

                  // Nombre del barbero
                  title: Text(
                    b['nombre'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Teléfono del barbero
                  subtitle: Text(
                    b['telefono'],
                    style: const TextStyle(color: Colors.white70),
                  ),

                  // Botón eliminar
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _eliminarBarbero(context, b.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ================= CREAR NUEVO BARBERO =================
  void _nuevoBarbero(BuildContext context) {
    final nombreController = TextEditingController();
    final telefonoController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),

        // Título del diálogo
        title: const Text(
          'Nuevo Barbero',
          style: TextStyle(color: Colors.white),
        ),

        // Campos del formulario
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _input(nombreController, 'Nombre'),
            _input(telefonoController, 'Teléfono'),
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

              // Guardar barbero en Firestore
              await FirebaseFirestore.instance.collection('barberos').add({
                'nombre': nombreController.text,
                'telefono': telefonoController.text,
                'activo': true,
                'creadoEn': Timestamp.now(),
              });

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ================= ELIMINAR BARBERO =================
  void _eliminarBarbero(BuildContext context, String barberoId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Eliminar barbero',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Estás seguro de eliminar este barbero?',
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
                  .collection('barberos')
                  .doc(barberoId)
                  .delete();

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ================= INPUT REUTILIZABLE =================
  Widget _input(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
