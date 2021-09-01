import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:productos_app/src/models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseURL = '192.168.1.81:8080';
  final List productos = [];
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
    } else {
      // INFO: actualizando
      print('Actualizando producto ${producto.nombre}');
      await this.actualizarProducto(producto);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> actualizarProducto(Producto producto) async {
    final endpoint = 'api/producto/${producto.id}';
    print('endpoint: $endpoint');
    final url = Uri.http(_baseURL, endpoint);
    final response = await http.put(
      url,
      body: producto.toJson(),
      // headers: {'content-type': 'multipart/form-data,boundary='},
    );

    final decodedData = ProductosResponse.fromJson(response.body);

    final index = productos.indexWhere((element) => element.id == producto.id);
    this.productos[index] = await obtenerProducto(producto.id);

    return decodedData.message;
  }
}
