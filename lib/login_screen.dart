import 'dart:convert';

import 'package:desing_ipscamv2/alerts_dialogs/DialogCredencialesIncorrectas.dart';
import 'package:desing_ipscamv2/alerts_dialogs/GenericDialog.dart';
import 'package:desing_ipscamv2/cod_utils/HttpGetRequest.dart';
import 'package:desing_ipscamv2/input_decoration.dart';
import 'package:desing_ipscamv2/main.dart';
import 'package:desing_ipscamv2/verificar_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/color_schemes.g.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: PantallaLogin(),
    );
  }
}

class PantallaLogin extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<PantallaLogin> {
  bool obscureText = true; // Inicialmente, la contraseña está oculta
  TextEditingController _txtUserController = TextEditingController();
  TextEditingController _txtPassController = TextEditingController();

  Future<void> saveToCache(String key, String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            cajasuperior(size),
            iconopersona(),
            SingleChildScrollView(
              child: columnalogin(context),
            ),
          ],
        ),
      ),
    );
  }

  Column columnalogin(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 250,
        ),
        Container(
          width: double.infinity,
          height: 320,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                )
              ]),
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              'Login',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
                child: Form(
              child: Column(
                children: [
                  TextFormField(
                      autocorrect: false,
                      controller: _txtUserController,
                      decoration: InputDecorations.inputDecoration(
                          hintext: 'micorreo@gmail.com',
                          labeltext: 'correo electronico',
                          errorText: '',
                          icono: const Icon(Icons.alternate_email_rounded))),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    autocorrect: false,
                    obscureText: obscureText,
                    controller: _txtPassController,
                    decoration: InputDecorations.inputPassDecoration(
                      hintext: '******',
                      labeltext: 'contraseña',
                      errorText: '',
                      icono: const Icon(Icons.lock_rounded),
                      iconEnd: IconButton(
                        icon: Icon(obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obscureText =
                                !obscureText; // Cambia el estado de la visibilidad de la contraseña
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ]),
        ),
        const SizedBox(
          height: 30,
        ),
        Center(
          child: Container(
            width: double.infinity, // Ocupa todo el ancho disponible
            height: 40,

            decoration: BoxDecoration(),
            margin: const EdgeInsets.fromLTRB(
                35, 25, 35, 35), // Espaciado alrededor del botón
            child: ElevatedButton(
              onPressed: () {
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VerificarScreen(
                            user: json.decode(
                                '{"email":"elmerjmejia55@gmail.com"}'))));*/
                IniciarSesion(_txtUserController.text, _txtPassController.text);
                //saveUserToCache(_txtUserController.text);
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Bordes redondeados
                  ),
                  backgroundColor: Color.fromRGBO(1, 72, 179, 1)),
              child: const Text(
                'INGRESAR',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> IniciarSesion(String email, String pass) async {
    HttpGetRequest httpRequest = HttpGetRequest();

    GenericDialog dialogCredencialesIncorrectas = GenericDialog(
      titulo: "Credenciales Incorrectas",
      cuerpo:
          "Por favor revise los datos ingresados en los campos y vuelva a intentarlos",
      icono: Icons.error,
      buttonTexto: "Cerrar",
    );
    dialogCredencialesIncorrectas.setButtonAction(
      () {
        Navigator.of(dialogCredencialesIncorrectas.getContext()).pop();
      },
    );

    String jsonData = '{"user": "$email","password":"$pass"}';
    final url = Uri.parse(
        'http://placas.inversa.hn/sandbox/auth'); // Reemplaza con tu URL de API

    String? response = await httpRequest.httpPost(url, jsonData, '');
    print(response);
    if (response != 'error') {
      final jsonResponse = json.decode(response!);

      if (jsonResponse['message'] == 'Inicio de sesion exitoso') {
        final resData = jsonResponse["data"];
        print(resData);
        final user = resData[0];
        await saveToCache('token', user["token"]);
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialogCredencialesIncorrectas;
          },
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialogCredencialesIncorrectas;
        },
      );
    }
  }

  SafeArea iconopersona() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 40),
        width: double.infinity,
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }

  Container cajasuperior(Size size) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xFF01B357),
        Color.fromRGBO(54, 131, 125, 1),
      ])),
      width: double.infinity,
      height: size.height * 0.4,
    );
  }
}
