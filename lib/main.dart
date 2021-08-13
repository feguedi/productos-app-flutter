import 'package:flutter/material.dart';

import 'package:productos_app/src/views/views.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos',
      initialRoute: LoginView.routName,
      routes: {
        LoginView.routName: (_) => LoginView(),
        HomeView.routName: (_) => HomeView(),
      },
      theme:
          ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.grey[100]),
    );
  }
}
