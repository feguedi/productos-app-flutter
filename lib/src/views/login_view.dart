import 'package:flutter/material.dart';

import 'package:productos_app/src/widgets/widgets.dart';

class LoginView extends StatelessWidget {
  static final String routName = 'login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 150),
            CardContainer(
              child: Column(
                children: [
                  Text(
                    'Ingreso',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
