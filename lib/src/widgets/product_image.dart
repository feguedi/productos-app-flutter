import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final double height;
  final double width;
  final String? url;

  const ProductImage(this.url, this.height, this.width);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Stack(children: [
        Container(
          decoration: _buildBoxDecoration(),
          width: double.infinity,
          height: 450,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: obtenerImagen(url),
          ),
        ),
        _fondo(this.height, this.width),
      ]),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
        ],
      );

  ClipRRect _fondo(height, width) => ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Container(
          height: height * 0.2,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black45,
                Colors.transparent,
              ],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
            ),
          ),
        ),
      );

  Widget obtenerImagen(String? imagen) {
    if (imagen == null) {
      return Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
      );
    }
    if (imagen.startsWith('http')) {
      return FadeInImage(
        image: NetworkImage(imagen),
        placeholder: AssetImage('assets/jar-loading.gif'),
        fit: BoxFit.cover,
      );
    }
    return Image.file(
      File(imagen),
      fit: BoxFit.cover,
    );
  }
}
