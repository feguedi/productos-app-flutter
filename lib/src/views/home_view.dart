import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/src/services/services.dart';
import 'package:productos_app/src/views/views.dart';
import 'package:productos_app/src/widgets/widgets.dart';

class HomeView extends StatelessWidget {
  static final String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () => Navigator.pushNamed(context, ProductView.routeName),
              child: ProductCard());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
