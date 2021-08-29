import 'package:flutter/material.dart';
import 'package:productos_app/src/colors/colors.dart';

import 'package:productos_app/src/widgets/widgets.dart';

class ProductView extends StatelessWidget {
  static final String routeName = 'product';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save_outlined),
        onPressed: () {
          // TODO: guardar producto
        },
      ),
      body: SafeArea(
        top: true,
        left: true,
        right: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ProductImage(size.height, size.width),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      onPressed: () {
                        // TODO: cámara o galería
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              _ProductForm(),
              SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  final width;

  const _ProductForm({Key? key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                Container(
                  // color: Colors.red,
                  margin: EdgeInsets.only(bottom: 25),
                  child: TextFormField(
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Nombre del producto',
                      labelText: 'Nombre:',
                    ),
                  ),
                ),
                Container(
                  // color: Colors.red,
                  margin: EdgeInsets.only(bottom: 25),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: '\$150',
                      labelText: 'Precio:',
                    ),
                  ),
                ),
                Container(
                  // color: Colors.red,
                  // margin: EdgeInsets.only(bottom: 25),
                  child: SwitchListTile.adaptive(
                      title: Text('Disponible'),
                      activeColor: Colors.indigo,
                      value: true,
                      onChanged: (value) {
                        // TODO: pendiente
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black26, offset: Offset(0, 5), blurRadius: 10),
        ]);
  }
}
