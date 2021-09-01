import 'dart:convert';

class ProductosResponse {
  String message;

  ProductosResponse({required this.message});

  factory ProductosResponse.fromJson(String str) =>
      ProductosResponse.fromMap(json.decode(str));

  factory ProductosResponse.fromMap(Map<String, dynamic> json) =>
      ProductosResponse(
        message: json['message'],
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        'message': message,
      };
}
