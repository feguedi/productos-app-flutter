import 'package:flutter/material.dart';

class NotificacionesService {
  static late GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String mensaje) {
    final snackBar = new SnackBar(
      content:
          Text(mensaje, style: TextStyle(color: Colors.white, fontSize: 20)),
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
