import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'ventas_page.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  // ================= FORMATO COP =================
  final NumberFormat _cop =
      NumberFormat.currency(locale: 'es_CO', symbol: '\$ ', decimalDigits: 0);

  // ================= FILTROS =================
  String filtroTexto = '';
  String categoriaSeleccionada = 'Todas';

  // ================= PRODUCTOS SELECCIONADOS =================
  final List<QueryDocumentSnapshot> productosSeleccionados = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Inventario de Productos',
          style: TextStyle(color: Colors.white),
        ),
      ),

      // ================= BOTÓN AGREGAR =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _nuevoProducto(context),
      ),

      // ================= BODY =================
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('productos')
            .orderBy('fechaEntrada', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final productos = snapshot.data!.docs;

          // 🔥 CATEGORÍAS DINÁMICAS
          final categorias = <String>{};
          for (var p in productos) {
            categorias.add(p['categoria']);
          }

          final listaCategorias = ['Todas', ...categorias.toList()];

          // 🔍 FILTRO
          final productosFiltrados = productos.where((p) {
            final nombre = p['nombre'].toString().toLowerCase();
            final codigo = p['codigo'].toString().toLowerCase();
            final categoria = p['categoria'];

            final matchTexto =
                nombre.contains(filtroTexto) || codigo.contains(filtroTexto);

            final matchCategoria = categoriaSeleccionada == 'Todas' ||
                categoriaSeleccionada == categoria;

            return matchTexto && matchCategoria;
          }).toList();

          return Column(
            children: [
              _filtros(listaCategorias),
              Expanded(child: _lista(productosFiltrados)),
            ],
          );
        },
      ),

      // ================= BOTÓN VENDER =================
      bottomNavigationBar: productosSeleccionados.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF1F1F1F),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.all(14),
                ),
                icon: const Icon(Icons.point_of_sale),
                label:
                    Text('VENDER (${productosSeleccionados.length})'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VentasPage(
                        productos: productosSeleccionados,
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  // ================= FILTROS =================
  Widget _filtros(List<String> categorias) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF1F1F1F),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Buscar por nombre o código',
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
              ),
              onChanged: (v) =>
                  setState(() => filtroTexto = v.toLowerCase()),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: categoriaSeleccionada,
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Categoría',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              items: categorias
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    ),
                  )
                  .toList(),
              onChanged: (v) =>
                  setState(() => categoriaSeleccionada = v!),
            ),
          ),
        ],
      ),
    );
  }

  // ================= LISTA =================
  Widget _lista(List<QueryDocumentSnapshot> productos) {
    if (productos.isEmpty) {
      return const Center(
        child: Text(
          'No hay productos',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _tablaEncabezado(),
        const SizedBox(height: 8),
        ...productos.map((p) => _filaProducto(p)),
      ],
    );
  }

  // ================= ENCABEZADO =================
  Widget _tablaEncabezado() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          SizedBox(width: 40),
          _Col('Código', 1),
          _Col('Producto', 2),
          _Col('Categoría', 2),
          _Col('Stock', 1),
          _Col('Precio', 1),
          _Col('Total', 1),
          SizedBox(width: 80),
        ],
      ),
    );
  }

  // ================= FILA PRODUCTO =================
  Widget _filaProducto(QueryDocumentSnapshot p) {
    final stock = p['stock'];
    final punto = p['puntoReposicion'];
    final bajo = stock <= punto;

    final seleccionado = productosSeleccionados.contains(p);

    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: bajo
            ? const BorderSide(color: Colors.redAccent, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            Checkbox(
              value: seleccionado,
              activeColor: Colors.teal,
              onChanged: (v) {
                setState(() {
                  v!
                      ? productosSeleccionados.add(p)
                      : productosSeleccionados.remove(p);
                });
              },
            ),
            _Col(p['codigo'], 1),
            _Col(p['nombre'], 2),
            _Col(p['categoria'], 2),
            _Col(
              stock.toString(),
              1,
              color: bajo ? Colors.redAccent : Colors.white,
            ),
            _Col(_cop.format(p['valorUnitario']), 1),
            _Col(
              _cop.format(p['valorUnitario'] * stock),
              1,
              color: Colors.tealAccent,
            ),
            IconButton(
              icon: const Icon(Icons.add_circle,
                  color: Colors.tealAccent),
              onPressed: () => _agregarStockDialog(p),
            ),
            IconButton(
              icon: const Icon(Icons.delete,
                  color: Colors.redAccent),
              onPressed: () => p.reference.delete(),
            ),
          ],
        ),
      ),
    );
  }

  // ================= AGREGAR STOCK =================
  void _agregarStockDialog(QueryDocumentSnapshot producto) {
    final cantidadCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Agregar Stock',
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(producto['nombre'],
                style: const TextStyle(
                    color: Colors.tealAccent,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: cantidadCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Cantidad a agregar',
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('Guardar'),
            onPressed: () async {
              final cantidad = int.tryParse(cantidadCtrl.text) ?? 0;
              if (cantidad <= 0) return;

              final stockActual = producto['stock'];
              final nuevoStock = stockActual + cantidad;

              await producto.reference.update({'stock': nuevoStock});

              await FirebaseFirestore.instance
                  .collection('entradas_stock')
                  .add({
                'productoId': producto.id,
                'nombreProducto': producto['nombre'],
                'cantidad': cantidad,
                'stockAnterior': stockActual,
                'stockNuevo': nuevoStock,
                'fecha': Timestamp.now(),
              });

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ================= NUEVO PRODUCTO =================
  void _nuevoProducto(BuildContext context) {
    final codigo = TextEditingController();
    final nombre = TextEditingController();
    final categoria = TextEditingController();
    final stock = TextEditingController();
    final punto = TextEditingController();
    final precio = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Nuevo Producto',
            style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _input(codigo, 'Código'),
              _input(nombre, 'Nombre'),
              _input(categoria, 'Categoría'),
              _input(stock, 'Stock',
                  tipo: TextInputType.number),
              _input(punto, 'Punto de reposición',
                  tipo: TextInputType.number),
              _input(precio, 'Valor unitario',
                  tipo: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('Guardar'),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('productos')
                  .add({
                'codigo': codigo.text,
                'nombre': nombre.text,
                'categoria': categoria.text,
                'stock': int.parse(stock.text),
                'puntoReposicion': int.parse(punto.text),
                'valorUnitario': int.parse(precio.text),
                'fechaEntrada': Timestamp.now(),
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _input(TextEditingController c, String label,
      {TextInputType tipo = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: tipo,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}

// ================= COLUMNA =================
class _Col extends StatelessWidget {
  final String text;
  final int flex;
  final Color color;

  const _Col(this.text, this.flex, {this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
