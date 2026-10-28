//======================================================================
// IMPORTACIONES
//======================================================================

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

//======================================================================
// CLOUDINARY SERVICE
//======================================================================

class CloudinaryService {



//======================================================================
// CONFIGURACIÓN CLOUDINARY
//======================================================================

static const String cloudName = "qv7abays";

static const String uploadPreset = "productos_app";

static const String uploadUrl =
    "https://api.cloudinary.com/v1_1/qv7abays/image/upload";


  //======================================================================
  // SUBIR IMAGEN
  //======================================================================

  Future<String?> subirImagen(File imagen) async {

    try {

      //==============================================================
      // OBTENER EL TIPO DE ARCHIVO
      //==============================================================

      final mimeType = lookupMimeType(imagen.path);

      //==============================================================
      // CREAR PETICIÓN HTTP
      //==============================================================

      final request = http.MultipartRequest(
        "POST",
        Uri.parse(uploadUrl),
      );

      //==============================================================
      // AGREGAR UPLOAD PRESET
      //==============================================================

      request.fields["upload_preset"] = uploadPreset;

      //==============================================================
      // AGREGAR IMAGEN A LA PETICIÓN
      //==============================================================

      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          imagen.path,
          contentType: MediaType.parse(
            mimeType ?? "image/jpeg",
          ),
        ),
      );

      //==============================================================
      // ENVIAR LA PETICIÓN A CLOUDINARY
      //==============================================================

      final response = await request.send();

      //==============================================================
      // CONVERTIR LA RESPUESTA A TEXTO
      //==============================================================

      final responseData =
          await response.stream.bytesToString();

      //==============================================================
      // CONVERTIR LA RESPUESTA A JSON
      //==============================================================

      final Map<String, dynamic> data =
          json.decode(responseData);

      //==============================================================
      // VALIDAR LA RESPUESTA
      //==============================================================

      if (response.statusCode == 200) {

        return data["secure_url"];

      } else {

        print("=================================");
        print("ERROR CLOUDINARY");
        print(data);
        print("=================================");

        return null;

      }

    } catch (e) {

      print("=================================");
      print("ERROR AL SUBIR IMAGEN");
      print(e);
      print("=================================");

      return null;

    }

  }
  
    //======================================================================
  // SUBIR MÚLTIPLES IMÁGENES
  //======================================================================

  Future<List<String>> subirMultiplesImagenes(
    List<File> imagenes,
  ) async {

    //==============================================================
    // LISTA DONDE SE ALMACENARÁN LAS URLS
    //==============================================================

    final List<String> urls = [];

    //==============================================================
    // RECORRER TODAS LAS IMÁGENES
    //==============================================================

    for (final imagen in imagenes) {

      //============================================================
      // SUBIR IMAGEN A CLOUDINARY
      //============================================================

      final String? url = await subirImagen(imagen);

      //============================================================
      // VALIDAR SI LA IMAGEN SE SUBIÓ CORRECTAMENTE
      //============================================================

      if (url != null && url.isNotEmpty) {

        urls.add(url);

      }

    }

    //==============================================================
    // RETORNAR TODAS LAS URLS
    //==============================================================

    return urls;

  }

  //======================================================================
  // ELIMINAR IMAGEN
  //======================================================================

  Future<bool> eliminarImagen(String publicId) async {

    try {

      //==============================================================
      // ESTE MÉTODO SE IMPLEMENTARÁ MÁS ADELANTE
      //==============================================================

      print("Eliminar imagen: $publicId");

      return true;

    } catch (e) {

      print("=================================");
      print("ERROR AL ELIMINAR IMAGEN");
      print(e);
      print("=================================");

      return false;

    }

  }

  //======================================================================
  // OBTENER PUBLIC ID
  //======================================================================

  String obtenerPublicId(String imageUrl) {

    //==============================================================
    // VALIDAR URL VACÍA
    //==============================================================

    if (imageUrl.isEmpty) {
      return "";
    }

    //==============================================================
    // ELIMINAR LA EXTENSIÓN DEL ARCHIVO
    //==============================================================

    final String sinExtension =
        imageUrl.substring(0, imageUrl.lastIndexOf("."));

    //==============================================================
    // BUSCAR LA POSICIÓN DE "upload/"
    //==============================================================

    final int indiceUpload =
        sinExtension.indexOf("/upload/");

    if (indiceUpload == -1) {
      return "";
    }

    //==============================================================
    // OBTENER LA RUTA DESPUÉS DE upload/
    //==============================================================

    String publicId =
        sinExtension.substring(indiceUpload + 8);

    //==============================================================
    // ELIMINAR LA VERSIÓN (v123456789)
    //==============================================================

    final partes = publicId.split("/");

    if (partes.isNotEmpty &&
        partes.first.startsWith("v")) {

      partes.removeAt(0);

    }

    //==============================================================
    // RETORNAR PUBLIC ID
    //==============================================================

    return partes.join("/");

  }

  //======================================================================
  // CONSTRUIR URL OPTIMIZADA
  //======================================================================

  String construirUrlOptimizada({
    required String imageUrl,
    int width = 800,
    int height = 800,
  }) {

    //==============================================================
    // VALIDAR URL
    //==============================================================

    if (imageUrl.isEmpty) {

      return "";

    }

    //==============================================================
    // TRANSFORMACIÓN CLOUDINARY
    //==============================================================

    const transformacion =
        "f_auto,q_auto,c_fill";

    //==============================================================
    // AGREGAR TAMAÑO
    //==============================================================

    final size =
        "w_$width,h_$height";

    //==============================================================
    // INSERTAR TRANSFORMACIÓN EN LA URL
    //==============================================================

    return imageUrl.replaceFirst(
      "/upload/",
      "/upload/$transformacion,$size/",
    );

  }
  //======================================================================
  // VALIDAR EXTENSIÓN
  //======================================================================

  bool validarExtension(File imagen) {

    //==============================================================
    // OBTENER LA EXTENSIÓN
    //==============================================================

    final extension = imagen.path
        .split(".")
        .last
        .toLowerCase();

    //==============================================================
    // EXTENSIONES PERMITIDAS
    //==============================================================

    const extensionesPermitidas = [

      "jpg",

      "jpeg",

      "png",

      "webp",

    ];

    //==============================================================
    // VALIDAR EXTENSIÓN
    //==============================================================

    return extensionesPermitidas.contains(extension);

  }
  //======================================================================
  // VALIDAR PESO
  //======================================================================

  bool validarPeso(
    File imagen, {
    int maximoMB = 5,
  }) {

    //==============================================================
    // OBTENER EL TAMAÑO
    //==============================================================

    final bytes = imagen.lengthSync();

    //==============================================================
    // CONVERTIR A MEGAS
    //==============================================================

    final megas =
        bytes / (1024 * 1024);

    //==============================================================
    // VALIDAR PESO
    //==============================================================

    return megas <= maximoMB;

  }
  //======================================================================
  // VALIDAR IMAGEN
  //======================================================================

  bool validarImagen(File imagen) {

    if (!validarExtension(imagen)) {

      return false;

    }

    if (!validarPeso(imagen)) {

      return false;

    }

    return true;

  }
  }