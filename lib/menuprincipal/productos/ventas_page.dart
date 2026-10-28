import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class VentasPage extends StatefulWidget {
  final List<QueryDocumentSnapshot> productos;

  const VentasPage({super.key, required this.productos});

  @override
  State<VentasPage> createState() => _VentasPageState();
}

class _VentasPageState extends State<VentasPage> {
  final NumberFormat cop =
      NumberFormat.currency(locale: 'es_CO', symbol: '\$ ', decimalDigits: 0);

  String? clienteId;
  String? vendedorId;
  String medioPago = 'Efectivo';
  bool pagado = true;

  @override
  Widget build(BuildContext context) {
    final total = widget.productos.fold<int>(
      0,
      (sum, p) => sum + (p['valorUnitario'] as int),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Confirmar Venta',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _selectorCliente(),
          const SizedBox(height: 12),
          _selectorBarbero(),
          const SizedBox(height: 20),
          _listaProductos(),
          const SizedBox(height: 20),
          _seccionPago(),
          const SizedBox(height: 20),
          Text(
            'TOTAL: ${cop.format(total)}',
            style: const TextStyle(
              color: Colors.tealAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () => _guardarVenta(total),
            child: const Text('CONFIRMAR VENTA'),
          ),
        ],
      ),
    );
  }

  // ================= CLIENTES =================
  Widget _selectorCliente() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('clientes').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        return DropdownButtonFormField<String>(
          dropdownColor: const Color(0xFF1E1E1E),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Cliente',
            labelStyle: TextStyle(color: Colors.white70),
          ),
          items: snapshot.data!.docs.map((c) {
            return DropdownMenuItem(
              value: c.id,
              child: Text(c['nombre']),
            );
          }).toList(),
          onChanged: (v) => setState(() => clienteId = v),
        );
      },
    );
  }

  // ================= BARBEROS =================
  Widget _selectorBarbero() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('barberos').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        return DropdownButtonFormField<String>(
          dropdownColor: const Color(0xFF1E1E1E),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Vendedor / Barbero',
            labelStyle: TextStyle(color: Colors.white70),
          ),
          items: snapshot.data!.docs.map((b) {
            return DropdownMenuItem(
              value: b.id,
              child: Text(b['nombre']),
            );
          }).toList(),
          onChanged: (v) => setState(() => vendedorId = v),
        );
      },
    );
  }

  // ================= PRODUCTOS =================
  Widget _listaProductos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Productos Seleccionados',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...widget.productos.map(
          (p) => ListTile(
            title: Text(
              p['nombre'],
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Text(
              cop.format(p['valorUnitario']),
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ],
    );
  }

  // ================= PAGO =================
  Widget _seccionPago() {
    return Column(
      children: [
        SwitchListTile(
          title:
              const Text('Pagado', style: TextStyle(color: Colors.white)),
          value: pagado,
          activeColor: Colors.teal,
          onChanged: (v) => setState(() => pagado = v),
        ),
        DropdownButtonFormField<String>(
          value: medioPago,
          dropdownColor: const Color(0xFF1E1E1E),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Medio de pago',
            labelStyle: TextStyle(color: Colors.white70),
          ),
          items: ['Efectivo', 'Transferencia', 'Tarjeta']
              .map((m) => DropdownMenuItem(value: m, child: Text(m)))
              .toList(),
          onChanged: (v) => setState(() => medioPago = v!),
        ),
      ],
    );
  }

  // ================= GUARDAR VENTA =================
  Future<void> _guardarVenta(int total) async {
    await FirebaseFirestore.instance.collection('ventas').add({
      'clienteId': clienteId,
      'vendedorId': vendedorId,
      'productos': widget.productos.map((p) {
        return {
          'productoId': p.id,
          'nombre': p['nombre'],
          'precio': p['valorUnitario'],
        };
      }).toList(),
      'total': total,
      'medioPago': medioPago,
      'pagado': pagado,
      'fecha': Timestamp.now(),
    });

    Navigator.pop(context);
  }
}
