import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/src/services/services.dart';
import 'package:productos_app/src/views/views.dart';

class CheckAuthView extends StatelessWidget {
  static final String routeName = 'checking';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final size = MediaQuery.of(context).size;
    final tipoImagen = 'monito';
    final imagen = Image(
      image: AssetImage('assets/$tipoImagen.gif'),
      width: size.width < 720 ? size.width * 0.8 : 720,
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Stack(
        children: [
          Center(
            child: FutureBuilder(
              future: authService.leerToken(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                print('data - ${snapshot.data}');

                if (!snapshot.hasData) {
                  return imagen;
                }

                if (snapshot.data == '') {
                  Future.microtask(() {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => LoginView(),
                          transitionDuration: Duration(seconds: 4),
                        ));
                  });
                }

                return imagen;
              },
            ),
          ),
        ],
      ),
    );
  }
}
