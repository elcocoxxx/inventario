import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiciosPage extends StatelessWidget {
  const ServiciosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      // ================= APPBAR =================
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

      // ================= BOTÓN AGREGAR =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _nuevoServicio(context),
      ),

      // ================= LISTA =================
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('servicios')
            .orderBy('creadoEn', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final servicios = snapshot.data!.docs;

          if (servicios.isEmpty) {
            return const Center(
              child: Text(
                'No hay servicios registrados',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            itemCount: servicios.length,
            itemBuilder: (_, i) {
              final s = servicios[i];

              return Card(
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.white10,
                    child: Icon(
                      Icons.content_cut,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  title: Text(
                    s['nombre'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '\$ ${s['precio']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => s.reference.delete(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ================= NUEVO SERVICIO =================
  void _nuevoServicio(BuildContext context) {
    final nombre = TextEditingController();
    final precio = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Nuevo Servicio',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _input(nombre, 'Nombre del servicio'),
            const SizedBox(height: 12),
            _input(precio, 'Precio'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
            ),
            onPressed: () {
              FirebaseFirestore.instance.collection('servicios').add({
                'nombre': nombre.text,
                'precio': double.parse(precio.text),
                'activo': true,
                'creadoEn': Timestamp.now(),
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  // ================= INPUT =================
  Widget _input(TextEditingController c, String label) {
    return TextField(
      controller: c,
      keyboardType:
          label == 'Precio' ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.pinkAccent),
        ),
      ),
    );
  }
}
