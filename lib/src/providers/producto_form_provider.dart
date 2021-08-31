import 'package:flutter/material.dart';
import 'package:productos_app/src/models/models.dart';

class ProductoFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Producto producto;

  ProductoFormProvider(this.producto);

  void updateAvailability(bool value) {
    print(value);
    this.producto.disponible = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
