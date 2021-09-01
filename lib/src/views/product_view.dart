import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:productos_app/src/colors/colors.dart';
import 'package:productos_app/src/providers/providers.dart';
import 'package:productos_app/src/services/services.dart';
import 'package:productos_app/src/widgets/widgets.dart';

class ProductView extends StatelessWidget {
  static final String routeName = 'product';

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    final size = MediaQuery.of(context).size;

    return ChangeNotifierProvider(
      create: (_) => ProductoFormProvider(productService.productoSeleccionado),
      child: _ProductViewBody(productService: productService, size: size),
    );
  }
}

class _ProductViewBody extends StatelessWidget {
  const _ProductViewBody({
    Key? key,
    required this.productService,
    required this.size,
  }) : super(key: key);

  final ProductsService productService;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final productoForm = Provider.of<ProductoFormProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save_outlined),
        onPressed: () async {
          if (!productoForm.isValidForm()) return;

          await productService.guardarOCrearProducto(productoForm.producto);
        },
      ),
      body: SafeArea(
        top: true,
        left: true,
        right: true,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          child: Column(
            children: [
              Stack(
                children: [
                  ProductImage(
                    productService.productoSeleccionado.imagen,
                    size.height,
                    size.width,
                  ),
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
                      onPressed: () async {
                        final picker = new ImagePicker();
                        final XFile? pickedFile = await picker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 60,
                        );

                        if (pickedFile == null) {
                          print('No seleccionó nada');
                          return;
                        }

                        print('Tenemos imagen ${pickedFile.path}');
                        productService.actualizarImagenProductoSeleccionado(
                            pickedFile.path);
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
    final productoForm = Provider.of<ProductoFormProvider>(context);
    final producto = productoForm.producto;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productoForm.formKey,
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                Container(
                  // color: Colors.red,
                  margin: EdgeInsets.only(bottom: 25),
                  child: TextFormField(
                    initialValue: producto.nombre,
                    onChanged: (value) => producto.nombre = value,
                    validator: (value) {
                      if (value == null || value.length < 1) {
                        return 'El nombre es obligatorio';
                      }
                    },
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
                    initialValue: producto.precio.toString(),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}')),
                    ],
                    onChanged: (value) {
                      if (double.tryParse(value) == null) {
                        producto.precio = 0;
                      } else {
                        producto.precio = double.parse(value);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.length < 1) {
                        return 'El precio es obligatorio';
                      }
                    },
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
                    value: producto.disponible,
                    onChanged: productoForm.updateAvailability,
                  ),
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
