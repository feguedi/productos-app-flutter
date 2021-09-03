import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/src/models/models.dart';
import 'package:productos_app/src/services/services.dart';
import 'package:productos_app/src/views/views.dart';
import 'package:productos_app/src/widgets/widgets.dart';

class HomeView extends StatelessWidget {
  static final String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final productsService = Provider.of<ProductsService>(context);

    if (productsService.isLoading) return LoadingView();

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton(
            onPressed: () async {
              await authService.logout();
              Navigator.pushReplacementNamed(context, LoginView.routeName);
            },
            icon: Icon(Icons.login_outlined),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: productsService.productos.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              productsService.productoSeleccionado =
                  productsService.productos[index].copy();
              Navigator.pushNamed(context, ProductView.routeName);
            },
            child: ProductCard(
              producto: productsService.productos[index],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          productsService.productoSeleccionado =
              new Producto(disponible: false, nombre: '', precio: 0);
          Navigator.pushNamed(context, ProductView.routeName);
        },
      ),
    );
  }
}
