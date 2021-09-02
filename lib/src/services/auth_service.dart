import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseURL = '192.168.1.89:8080';
  final String _loginEndpoint = '/api/login';
  final String _registrarEndpoint = '/api/usuario';

  Future<Map<String, dynamic>> crearUsuario(
      String email, String password) async {
    final Map<String, dynamic> authData = {
      'correoElectronico': email,
      'contrasenia': password,
    };
    final url = Uri.http(_baseURL, _registrarEndpoint);
    final response = await http.post(url, body: authData);
    final Map<String, dynamic> decodedResponse = json.decode(response.body);

    print(decodedResponse.toString());

    return {
      'statusCode': response.statusCode,
      'ok': response.statusCode < 300 && response.statusCode >= 200,
    };
  }
}
