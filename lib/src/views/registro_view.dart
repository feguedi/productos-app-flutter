import 'package:flutter/material.dart';
import 'package:productos_app/src/services/services.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/src/colors/colors.dart';
import 'package:productos_app/src/providers/providers.dart';
import 'package:productos_app/src/widgets/widgets.dart';

class RegistroView extends StatelessWidget {
  static final String routeName = 'registro';

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
                    'Registro',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  ChangeNotifierProvider(
                    create: (_) => LoginFormProvider(),
                    child: _RegistroForm(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'login');
              },
              child: Text(
                'Ingresar con tu cuenta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class _RegistroForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: loginForm.formKey,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'pedro.paramo@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_sharp,
              ),
              onChanged: (value) => loginForm.correo = value,
              validator: (String? value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'No es un correo válido';
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              autocorrect: false,
              decoration: InputDecorations.authInputDecoration(
                hintText: '************',
                labelText: 'Contraseña',
                prefixIcon: Icons.password,
              ),
              onChanged: (value) => loginForm.contra = value,
              validator: (value) {
                bool isValid = value != null && value.length >= 6;

                return isValid
                    ? null
                    : 'La contraseña debe ser de 6 caracteres';
              },
            ),
            SizedBox(height: 20),
            MaterialButton(
              disabledColor: Colors.grey,
              elevation: 5,
              color: Colors.deepPurple,
              shape: StadiumBorder(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  loginForm.isLoading
                      ? 'Espere'.toUpperCase()
                      : 'Registrarme'.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      if (!loginForm.isValidForm()) return;

                      loginForm.isLoading = true;

                      final Map<String, dynamic> response = await authService
                          .crearUsuario(loginForm.correo, loginForm.contra);

                      loginForm.isLoading = false;

                      if (response['ok']) {
                        Navigator.pushReplacementNamed(context, 'home');
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
