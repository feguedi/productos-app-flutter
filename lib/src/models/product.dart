import 'dart:convert';

class Productos {
  int total;
  List<Producto> productos;

  Productos({
    required this.total,
    required this.productos,
  });

  factory Productos.fromJson(String str) => Productos.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  factory Productos.fromMap(Map<String, dynamic> json) => Productos(
        total: json['total'],
        productos: List<Producto>.from(
            json['productos'].map((x) => Producto.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'total': total,
        'productos': List<dynamic>.from(productos.map((x) => x.toMap())),
      };
}

class Producto {
  bool disponible;
  String id;
  String nombre;
  String? imagen;
  double precio;

  Producto({
    required this.disponible,
    required this.id,
    required this.nombre,
    required this.precio,
    this.imagen,
  });

  factory Producto.fromJson(String str) => Producto.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  factory Producto.fromMap(Map<String, dynamic> json) => Producto(
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
