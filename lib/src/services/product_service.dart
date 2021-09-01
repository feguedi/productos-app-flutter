// https://roytuts.com/boundary-in-multipart-form-data
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:productos_app/src/models/models.dart';

class ProductsService extends ChangeNotifier {
  File? nuevaImagen;
  final String _baseURL = '192.168.1.81:8080';
  final List<Producto> productos = [];
  late Producto productoSeleccionado;
  bool isLoading = true;
  bool isSaving = false;

  ProductsService() {
    this._loadProductos();
  }

  Future _loadProductos() async {
    this.isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseURL, 'api/productos');
    final response = await http.get(url);

    final Map<String, dynamic> responseMap = json.decode(response.body);
    final tmpProductos = Productos.fromMap(responseMap);

    tmpProductos.productos.forEach((producto) {
      productos.add(producto);
    });

    this.isLoading = false;
    notifyListeners();
  }

  Future<Producto> obtenerProducto(String id) async {
    final endpoint = 'api/producto/$id';
    final url = Uri.http(_baseURL, endpoint);
    final response = await http.get(url);
    final producto = Producto.fromJson(response.body);

    return producto;
  }

  Future guardarOCrearProducto(Producto producto) async {
    isSaving = true;
    notifyListeners();

    if (producto.id == null) {
      // INFO: creando
      print('Creando producto');
      final mensaje = await crearProducto(producto);

      print(mensaje);
    } else {
      // INFO: actualizando
      print('Actualizando producto ${producto.nombre}');
      await this.actualizarProducto(producto);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> crearProducto(Producto producto) async {
    this.isSaving = true;
    notifyListeners();
    final url = Uri.http(_baseURL, 'api/producto');
    final request = http.MultipartRequest('POST', url)
      ..fields['nombre'] = producto.nombre
      ..fields['precio'] = producto.precio.toString()
      ..fields['disponible'] = producto.disponible.toString();
    if (nuevaImagen != null) {
      request.files
          .add(await http.MultipartFile.fromPath('imagen', nuevaImagen!.path));
    }
    // if (producto.imagen != null) request.files.add(await http.MultipartFile.fromPath(field, 'filePath');
    //   method:
    //   url,
    //   body: producto.toJson(),
    //   headers: {
    //     'content-type': producto.imagen == null
    //         ? 'application/json'
    //         : 'multipart/form-data;boundary='
    //   },
    // );

    final streamResponse = await request.send();

    // final decodedData = ProductosResponse.fromJson(response.toString());
    final response = await http.Response.fromStream(streamResponse);
    final decodedData = ProductosResponse.fromJson(response.body.toString());
    print('decodedData: ${decodedData.message}');
    this.isSaving = false;
    notifyListeners();

    await _loadProductos();

    return decodedData.message;
  }

  Future<String> actualizarProducto(Producto producto) async {
    this.isSaving = true;
    notifyListeners();
    final endpoint = 'api/producto/${producto.id}';
    print('endpoint: $endpoint');
    final url = Uri.http(_baseURL, endpoint);
    final request = http.MultipartRequest('PUT', url)
      ..fields['nombre'] = producto.nombre
      ..fields['precio'] = producto.precio.toString()
      ..fields['disponible'] = producto.disponible.toString();

    if (nuevaImagen != null) {
      request.files
          .add(await http.MultipartFile.fromPath('imagen', nuevaImagen!.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print('response: ${response.body.toString()}');
    this.isSaving = false;

    if (response.statusCode < 400) {
      notifyListeners();
    }

    final decodedData = ProductosResponse.fromJson(response.body.toString());
    print('decodedData: ${decodedData.message}');

    final index = productos.indexWhere((element) => element.id == producto.id!);
    this.productos[index] = await obtenerProducto(producto.id!);

    return decodedData.message;
  }

  void actualizarImagenProductoSeleccionado(String path) {
    this.productoSeleccionado.imagen = path;
    this.nuevaImagen = File.fromUri(Uri(path: path));
    notifyListeners();
  }
}
