//======================================================================
// IMPORTACIONES
//======================================================================

import 'package:cloud_firestore/cloud_firestore.dart';

//======================================================================
// MODELO PRODUCTO
//======================================================================

class Producto {

  //====================================================================
  // IDENTIFICACIÓN
  //====================================================================

  final String id;
  final String codigo;
  final String codigoBarras;

  //====================================================================
  // INFORMACIÓN GENERAL
  //====================================================================

  final String nombre;
  final String descripcion;
  final String categoria;
  final String marca;

  //====================================================================
  // IMÁGENES
  //====================================================================

  final String imagen;
  final List<String> imagenes;

  //====================================================================
  // PRECIOS
  //====================================================================

  final double precioCompra;
  final double precioVenta;

  //====================================================================
  // INVENTARIO
  //====================================================================

  final int stock;
  final int stockMinimo;
  final int vendidos;

  //====================================================================
  // PROVEEDOR
  //====================================================================

  final String proveedor;

  //====================================================================
  // ETIQUETAS
  //====================================================================

  final List<String> etiquetas;

  //====================================================================
  // ESTADO
  //====================================================================

  final bool activo;

  //====================================================================
  // FECHAS
  //====================================================================

  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;
  final DateTime? fechaVencimiento;

  //====================================================================
  // CONSTRUCTOR
  //====================================================================

  const Producto({
    required this.id,
    required this.codigo,
    required this.codigoBarras,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.marca,
    required this.imagen,
    required this.imagenes,
    required this.precioCompra,
    required this.precioVenta,
    required this.stock,
    required this.stockMinimo,
    required this.vendidos,
    required this.proveedor,
    required this.etiquetas,
    required this.activo,
    required this.fechaCreacion,
    required this.fechaActualizacion,
    this.fechaVencimiento,
  });
  // 2

    //====================================================================
  // COPY WITH
  //====================================================================

  Producto copyWith({
    String? id,
    String? codigo,
    String? codigoBarras,
    String? nombre,
    String? descripcion,
    String? categoria,
    String? marca,
    String? imagen,
    List<String>? imagenes,
    double? precioCompra,
    double? precioVenta,
    int? stock,
    int? stockMinimo,
    int? vendidos,
    String? proveedor,
    List<String>? etiquetas,
    bool? activo,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaVencimiento,
  }) {
    return Producto(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      marca: marca ?? this.marca,
      imagen: imagen ?? this.imagen,
      imagenes: imagenes ?? this.imagenes,
      precioCompra: precioCompra ?? this.precioCompra,
      precioVenta: precioVenta ?? this.precioVenta,
      stock: stock ?? this.stock,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      vendidos: vendidos ?? this.vendidos,
      proveedor: proveedor ?? this.proveedor,
      etiquetas: etiquetas ?? this.etiquetas,
      activo: activo ?? this.activo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion:
          fechaActualizacion ?? this.fechaActualizacion,
      fechaVencimiento:
          fechaVencimiento ?? this.fechaVencimiento,
    );
  }
  //====================================================================
  // TO MAP
  //====================================================================

  Map<String, dynamic> toMap() {
    return {
      // Identificación
      "id": id,
      "codigo": codigo,
      "codigoBarras": codigoBarras,

      // Información General
      "nombre": nombre,
      "descripcion": descripcion,
      "categoria": categoria,
      "marca": marca,

      // Imágenes
      "imagen": imagen,
      "imagenes": imagenes,

      // Precios
      "precioCompra": precioCompra,
      "precioVenta": precioVenta,

      // Inventario
      "stock": stock,
      "stockMinimo": stockMinimo,
      "vendidos": vendidos,

      // Proveedor
      "proveedor": proveedor,

      // Etiquetas
      "etiquetas": etiquetas,

      // Estado
      "activo": activo,

      // Fechas
      "fechaCreacion": Timestamp.fromDate(fechaCreacion),
      "fechaActualizacion": Timestamp.fromDate(fechaActualizacion),
      "fechaVencimiento": fechaVencimiento != null
          ? Timestamp.fromDate(fechaVencimiento!)
          : null,
    };
  }
  //====================================================================
  // FROM MAP
  //====================================================================

  factory Producto.fromMap(Map<String, dynamic> map) {

    DateTime convertirFecha(dynamic valor) {

      if (valor == null) {
        return DateTime.now();
      }

      if (valor is Timestamp) {
        return valor.toDate();
      }

      if (valor is DateTime) {
        return valor;
      }

      if (valor is String) {
        return DateTime.tryParse(valor) ?? DateTime.now();
      }

      return DateTime.now();
    }

    DateTime? convertirFechaOpcional(dynamic valor) {

      if (valor == null) {
        return null;
      }

      if (valor is Timestamp) {
        return valor.toDate();
      }

      if (valor is DateTime) {
        return valor;
      }

      if (valor is String) {
        return DateTime.tryParse(valor);
      }

      return null;
    }

    return Producto(

      //==============================================================
      // IDENTIFICACIÓN
      //==============================================================

      id: map["id"] ?? "",

      codigo: map["codigo"] ?? "",

      codigoBarras: map["codigoBarras"] ?? "",

      //==============================================================
      // INFORMACIÓN GENERAL
      //==============================================================

      nombre: map["nombre"] ?? "",

      descripcion: map["descripcion"] ?? "",

      categoria: map["categoria"] ?? "",

      marca: map["marca"] ?? "",

      //==============================================================
      // IMÁGENES
      //==============================================================

      imagen: map["imagen"] ?? "",

      imagenes: List<String>.from(
        map["imagenes"] ?? [],
      ),

      //==============================================================
      // PRECIOS
      //==============================================================

      precioCompra: (map["precioCompra"] ?? 0).toDouble(),

      precioVenta: (map["precioVenta"] ?? 0).toDouble(),

      //==============================================================
      // INVENTARIO
      //==============================================================

      stock: map["stock"] ?? 0,

      stockMinimo: map["stockMinimo"] ?? 0,

      vendidos: map["vendidos"] ?? 0,

      //==============================================================
      // PROVEEDOR
      //==============================================================

      proveedor: map["proveedor"] ?? "",

      //==============================================================
      // ETIQUETAS
      //==============================================================

      etiquetas: List<String>.from(
        map["etiquetas"] ?? [],
      ),

      //==============================================================
      // ESTADO
      //==============================================================

      activo: map["activo"] ?? true,

      //==============================================================
      // FECHAS
      //==============================================================

      fechaCreacion: convertirFecha(
        map["fechaCreacion"],
      ),

      fechaActualizacion: convertirFecha(
        map["fechaActualizacion"],
      ),

      fechaVencimiento: convertirFechaOpcional(
        map["fechaVencimiento"],
      ),

    );

  }

  //====================================================================
  // FROM FIRESTORE
  //====================================================================

  factory Producto.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {

    final data = document.data();

    if (data == null) {
      throw Exception("El documento no contiene información.");
    }

    return Producto.fromMap({
      ...data,
      "id": document.id,
    });

  }

  //====================================================================
  // TO FIRESTORE
  //====================================================================

  Map<String, dynamic> toFirestore() {

    final data = toMap();

    data.remove("id");

    return data;

  }
  //====================================================================
  // TO STRING
  //====================================================================

  @override
  String toString() {
    return '''
═══════════════════════════════════════════════
Producto

ID: $id
Código: $codigo
Código Barras: $codigoBarras

Nombre: $nombre
Descripción: $descripcion
Categoría: $categoria
Marca: $marca

Imagen: $imagen

Precio Compra: $precioCompra
Precio Venta: $precioVenta

Stock: $stock
Stock Mínimo: $stockMinimo
Vendidos: $vendidos

Proveedor: $proveedor

Etiquetas: $etiquetas

Activo: $activo

Fecha Creación: $fechaCreacion
Fecha Actualización: $fechaActualizacion
Fecha Vencimiento: $fechaVencimiento
═══════════════════════════════════════════════
''';
  }

  //====================================================================
  // OPERATOR ==
  //====================================================================

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Producto &&
        other.id == id &&
        other.codigo == codigo &&
        other.codigoBarras == codigoBarras &&
        other.nombre == nombre &&
        other.descripcion == descripcion &&
        other.categoria == categoria &&
        other.marca == marca &&
        other.imagen == imagen &&
        other.precioCompra == precioCompra &&
        other.precioVenta == precioVenta &&
        other.stock == stock &&
        other.stockMinimo == stockMinimo &&
        other.vendidos == vendidos &&
        other.proveedor == proveedor &&
        other.activo == activo &&
        other.fechaCreacion == fechaCreacion &&
        other.fechaActualizacion == fechaActualizacion &&
        other.fechaVencimiento == fechaVencimiento;
  }

  //====================================================================
  // HASH CODE
  //====================================================================

  @override
  int get hashCode {
    return Object.hash(
      id,
      codigo,
      codigoBarras,
      nombre,
      descripcion,
      categoria,
      marca,
      imagen,
      imagenes,
      precioCompra,
      precioVenta,
      stock,
      stockMinimo,
      vendidos,
      proveedor,
      etiquetas,
      activo,
      fechaCreacion,
      fechaActualizacion,
      fechaVencimiento,
    );
  }

}