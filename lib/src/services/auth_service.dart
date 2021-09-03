import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseURL = '192.168.1.89:8080';
  final String _loginEndpoint = '/api/login';
  final String _registrarEndpoint = '/api/usuario';
  final storage = new FlutterSecureStorage();

  Future<String?> crearUsuario(String email, String password) async {
    final Map<String, dynamic> authData = {
      'correoElectronico': email,
      'contrasenia': password,
    };
    final url = Uri.http(_baseURL, _registrarEndpoint);
    final response = await http.post(url, body: authData);
    final Map<String, dynamic> decodedResponse = json.decode(response.body);

    if (decodedResponse.containsKey('token')) {
      // return decodedResponse['token'];
      await storage.write(key: 'token', value: decodedResponse['token']);
      return null;
    } else {
      return decodedResponse['message'];
    }
  }

  Future<String?> ingresarUsuario(String email, String password) async {
    final Map<String, dynamic> authData = {
      'correoElectronico': email,
      'contrasenia': password,
    };
    final url = Uri.http(_baseURL, _loginEndpoint);
    final response = await http.post(url, body: authData);
    final Map<String, dynamic> decodedResponse = json.decode(response.body);

    if (decodedResponse.containsKey('token')) {
      await storage.write(key: 'token', value: decodedResponse['token']);
      return null;
    } else {
      return decodedResponse['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
  }

  Future<String> leerToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
