import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/src/services/services.dart';
import 'package:productos_app/src/views/views.dart';

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductsService(),
        )
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos',
      initialRoute: LoginView.routeName,
      routes: {
        LoginView.routeName: (_) => LoginView(),
        RegistroView.routeName: (_) => RegistroView(),
        ProductView.routeName: (_) => ProductView(),
        HomeView.routeName: (_) => HomeView(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo,
          centerTitle: true,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              overlayColor:
                  MaterialStateProperty.all(Colors.indigo.withOpacity(0.5)),
              shape: MaterialStateProperty.all(StadiumBorder()),
              textStyle:
                  MaterialStateProperty.all(TextStyle(color: Colors.indigo))),
        ),
      ),
    );
  }
}

void main() => runApp(AppState());
