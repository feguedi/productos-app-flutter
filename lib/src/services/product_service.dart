// https://roytuts.com/boundary-in-multipart-form-data
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:productos_app/src/models/models.dart';
import 'package:productos_app/src/services/notificaciones_service.dart';

class ProductsService extends ChangeNotifier {
  File? nuevaImagen;
  // final String _baseURL = '192.168.1.81:8080';
  final String _baseURL = '192.168.1.89:8080';
  final _storage = new FlutterSecureStorage();
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
    final String? token = await _storage.read(key: 'token');

    if (token == null || token == '') {
      NotificacionesService.showSnackbar('No se pueden obtener los productos');
    } else {
      final url = Uri.http(_baseURL, 'api/productos');
      final response =
          await http.get(url, headers: {'authorization': 'Bearer $token'});

      final Map<String, dynamic> responseMap = json.decode(response.body);

      if (response.statusCode >= 400) {
        NotificacionesService.showSnackbar(responseMap['message']);
      } else {
        final tmpProductos = Productos.fromMap(responseMap);

        tmpProductos.productos.forEach((producto) {
          final index =
              productos.indexWhere((element) => element.id == producto.id);
          if (index < 0) {
            productos.add(producto);
          }
        });
      }
    }

    this.isLoading = false;
    notifyListeners();
  }

  Future<Producto> obtenerProducto(String id) async {
    final String? token = await _storage.read(key: 'token');
    final endpoint = 'api/producto/$id';
    final url = Uri.http(_baseURL, endpoint);
    final response =
        await http.get(url, headers: {'authorization': 'Bearer $token'});
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
      final mensaje = await this.actualizarProducto(producto);

      print(mensaje);
    }

    await _loadProductos();
    isSaving = false;
    notifyListeners();
  }

  Future<String> crearProducto(Producto producto) async {
    this.isSaving = true;
    notifyListeners();

    final String? token = await _storage.read(key: 'token');
    final url = Uri.http(_baseURL, 'api/producto');
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['nombre'] = producto.nombre
      ..fields['precio'] = producto.precio.toString()
      ..fields['disponible'] = producto.disponible.toString();

    if (nuevaImagen != null) {
      request.files
          .add(await http.MultipartFile.fromPath('imagen', nuevaImagen!.path));
    }

    final streamResponse = await request.send();

    final response = await http.Response.fromStream(streamResponse);
    final decodedData = ProductosResponse.fromJson(response.body.toString());

    this.nuevaImagen = null;
    this.isSaving = false;
    notifyListeners();

    return decodedData.message;
  }

  Future<String> actualizarProducto(Producto producto) async {
    this.isSaving = true;
    notifyListeners();

    final String? token = await _storage.read(key: 'token');
    final endpoint = 'api/producto/${producto.id}';
    final url = Uri.http(_baseURL, endpoint);
    final request = http.MultipartRequest('PUT', url)
      ..fields['nombre'] = producto.nombre
      ..fields['precio'] = producto.precio.toString()
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['disponible'] = producto.disponible.toString();

    if (nuevaImagen != null) {
      request.files
          .add(await http.MultipartFile.fromPath('imagen', nuevaImagen!.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    final decodedData = ProductosResponse.fromJson(response.body.toString());

    final index = productos.indexWhere((element) => element.id == producto.id!);
    this.productos[index] = await obtenerProducto(producto.id!);

    this.nuevaImagen = null;

    this.isSaving = false;
    notifyListeners();

    return decodedData.message;
  }

  void actualizarImagenProductoSeleccionado(String path) {
    this.productoSeleccionado.imagen = path;
    this.nuevaImagen = File.fromUri(Uri(path: path));
    notifyListeners();
  }
}
