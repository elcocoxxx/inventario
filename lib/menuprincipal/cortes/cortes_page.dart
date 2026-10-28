import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CortesPage extends StatefulWidget {
  const CortesPage({super.key});

  @override
  State<CortesPage> createState() => _CortesPageState();
}

class _CortesPageState extends State<CortesPage> {
  String? clienteId;
  String? clienteNombre;
  String? barberoId;
  String? barberoNombre;
  String? servicioId;
  String? servicioNombre;
  int valor = 0;

  DateTime fechaCorte = DateTime.now();

  final NumberFormat cop =
      NumberFormat.currency(locale: 'es_CO', symbol: '\$ ', decimalDigits: 0);

  final DateFormat fechaFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Nuevo Corte',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ================= FECHA =================
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _tituloSeccion('Fecha del corte'),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          fechaFormat.format(fechaCorte),
                          style: const TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_month,
                            color: Colors.white),
                        onPressed: _seleccionarFecha,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= CLIENTE =================
            _card(
              child: Column(
                children: [
                  _tituloSeccion('Cliente'),
                  _clientesDropdown(),
                  _crearClienteBtn(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= BARBERO =================
            _card(
              child: Column(
                children: [
                  _tituloSeccion('Barbero'),
                  _barberosDropdown(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= SERVICIO =================
            _card(
              child: Column(
                children: [
                  _tituloSeccion('Servicio'),
                  _serviciosDropdown(),
                  const SizedBox(height: 12),
                  Text(
                    'Valor: ${cop.format(valor)}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.tealAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _guardarCorte,
              child: const Text(
                'Guardar Corte',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= FECHA =================
  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: fechaCorte,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );

    if (fecha != null) {
      setState(() => fechaCorte = fecha);
    }
  }

  // ================= CLIENTES =================
  Widget _clientesDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('clientes').snapshots(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        return DropdownButtonFormField<String>(
          dropdownColor: const Color(0xFF1E1E1E),
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration('Seleccionar cliente'),
          items: snapshot.data!.docs.map((doc) {
            return DropdownMenuItem(
              value: doc.id,
              child: Text(doc['nombre']),
            );
          }).toList(),
          onChanged: (id) {
            final doc = snapshot.data!.docs.firstWhere((e) => e.id == id);
            setState(() {
              clienteId = id;
              clienteNombre = doc['nombre'];
            });
          },
        );
      },
    );
  }

  Widget _crearClienteBtn() {
    return TextButton.icon(
      icon: const Icon(Icons.person_add, color: Colors.tealAccent),
      label: const Text(
        'Crear nuevo cliente',
        style: TextStyle(color: Colors.tealAccent),
      ),
      onPressed: _crearClienteDialog,
    );
  }

  void _crearClienteDialog() {
    final nombre = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Nuevo Cliente',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: nombre,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration('Nombre del cliente'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () async {
              final doc = await FirebaseFirestore.instance
                  .collection('clientes')
                  .add({'nombre': nombre.text});
              setState(() {
                clienteId = doc.id;
                clienteNombre = nombre.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  // ================= BARBEROS =================
  Widget _barberosDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('barberos').snapshots(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        return DropdownButtonFormField<String>(
          dropdownColor: const Color(0xFF1E1E1E),
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration('Seleccionar barbero'),
          items: snapshot.data!.docs.map((doc) {
            return DropdownMenuItem(
              value: doc.id,
              child: Text(doc['nombre']),
            );
          }).toList(),
          onChanged: (id) {
            final doc = snapshot.data!.docs.firstWhere((e) => e.id == id);
            setState(() {
              barberoId = id;
              barberoNombre = doc['nombre'];
            });
          },
        );
      },
    );
  }

  // ================= SERVICIOS =================
  Widget _serviciosDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('servicios').snapshots(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        return DropdownButtonFormField<String>(
          dropdownColor: const Color(0xFF1E1E1E),
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration('Seleccionar servicio'),
          items: snapshot.data!.docs.map((doc) {
            return DropdownMenuItem(
              value: doc.id,
              child: Text(doc['nombre']),
            );
          }).toList(),
          onChanged: (id) {
            final doc = snapshot.data!.docs.firstWhere((e) => e.id == id);
            setState(() {
              servicioId = id;
              servicioNombre = doc['nombre'];
              valor = doc['precio'];
            });
          },
        );
      },
    );
  }

  // ================= GUARDAR =================
  Future<void> _guardarCorte() async {
    if (clienteId == null || barberoId == null || servicioId == null) return;

    await FirebaseFirestore.instance.collection('cortes').add({
      'clienteId': clienteId,
      'clienteNombre': clienteNombre,
      'barberoId': barberoId,
      'barberoNombre': barberoNombre,
      'servicioId': servicioId,
      'servicioNombre': servicioNombre,
      'valor': valor,
      'fecha': Timestamp.fromDate(fechaCorte),
      'creadoEn': Timestamp.now(),
    });

    Navigator.pop(context);
  }

  // ================= UI HELPERS =================
  Widget _card({required Widget child}) {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _tituloSeccion(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white30),
      ),
    );
  }
}
