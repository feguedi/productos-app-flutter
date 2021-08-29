import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:productos_app/src/models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseURL = '192.168.1.81:8080';
  final List productos = [];
  bool isLoading = true;

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
}
