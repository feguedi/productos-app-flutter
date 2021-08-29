import 'dart:convert';

class Productos {
  int total;
  List<_Producto> productos;

  Productos({
    required this.total,
    required this.productos,
  });

  factory Productos.fromJson(String str) => Productos.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  factory Productos.fromMap(Map<String, dynamic> json) => Productos(
        total: json['total'],
        productos: List<_Producto>.from(
            json['productos'].map((x) => _Producto.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'total': total,
        'productos': List<dynamic>.from(productos.map((x) => x.toMap())),
      };
}

class _Producto {
  bool disponible;
  String id;
  String nombre;
  String? imagen;
  double precio;

  _Producto({
    required this.disponible,
    required this.id,
    required this.nombre,
    required this.precio,
    this.imagen,
  });

  factory _Producto.fromJson(String str) => _Producto.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  factory _Producto.fromMap(Map<String, dynamic> json) => _Producto(
        disponible: json['disponible'],
        id: json['_id'],
        nombre: json['nombre'],
        precio: json['precio'].toDouble(),
        imagen: json['imagen'] == null ? null : json['imagen'],
      );

  Map<String, dynamic> toMap() => {
        'disponible': disponible,
        '_id': id,
        'nombre': nombre,
        'precio': precio,
        'imagen': imagen,
      };
}
