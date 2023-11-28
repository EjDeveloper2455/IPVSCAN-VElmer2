import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:desing_ipscamv2/alerts_dialogs/DialogCredencialesIncorrectas.dart';
import 'package:desing_ipscamv2/alerts_dialogs/GenericDialog.dart';
import 'package:desing_ipscamv2/cod_utils/HttpGetRequest.dart';
import 'package:desing_ipscamv2/input_decoration.dart';
import 'package:desing_ipscamv2/main.dart';
import 'package:desing_ipscamv2/restablecer_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificarScreen extends StatelessWidget {
  final Map<String, dynamic> user;
  VerificarScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        //systemNavigationBarColor: Theme.of(context).primaryColor,
      ),
      home: PantallaVerificar(user: user),
    );
  }
}

class PantallaVerificar extends StatefulWidget {
  final Map<String, dynamic> user;
  PantallaVerificar({required this.user});
  @override
  // ignore: no_logic_in_create_state
  LoginState createState() => LoginState(user: user);
}

class LoginState extends State<PantallaVerificar> {
  final Map<String, dynamic> user;
  LoginState({required this.user});
  bool obscureText = true; // Inicialmente, la contraseña está oculta
  TextEditingController _txtController = TextEditingController();
  String _errorText = '';

  String enviar = "ENVIAR";
  int counter = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // Inicia el temporizador que incrementa el contador cada segundo.
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (counter > 0) counter--;
      });
    });
  }

  @override
  void dispose() {
    // Detiene el temporizador cuando se destruye el widget para evitar fugas de memoria.
    timer.cancel();
    super.dispose();
  }

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
          child: SingleChildScrollView(
            child: Stack(
              children: [
                SingleChildScrollView(child: columnalogin(context)),
              ],
            ),
          )),
    );
  }

  Column columnalogin(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 80,
        ),
        Container(
          width: double.infinity,
          height: _errorText.isEmpty ? 520 : 550,
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
            iconopersona(),
            Text(
              'Verificar correo electrónico',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                child: Form(
              child: Column(
                children: [
                  TextFormField(
                      autocorrect: false,
                      controller: _txtController,
                      decoration: InputDecorations.inputDecoration(
                          hintext: 'xxxxxx',
                          errorText: _errorText,
                          labeltext: 'Código de verificación',
                          icono: const Icon(Icons.code))),
                  Padding(padding: EdgeInsets.all(10)),
                  Text(
                      // ignore: prefer_interpolation_to_compose_strings
                      'Se enviará un codigo de verificación al siguiente correo: "' +
                          user["email"] +
                          '"',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Center(
                    child: Container(
                      width: double.infinity, // Ocupa todo el ancho disponible
                      height: 40,

                      decoration: BoxDecoration(),
                      margin: const EdgeInsets.fromLTRB(
                          35, 25, 35, 35), // Espaciado alrededor del botón
                      child: ElevatedButton(
                        onPressed: counter == 0
                            ? () {
                                EnviarEmail(user["email"]);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Bordes redondeados
                            ),
                            backgroundColor: Color.fromRGBO(1, 72, 179, 1)),
                        child: Text(
                          enviar + getCounterString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
          ]),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Container(
            width: double.infinity, // Ocupa todo el ancho disponible
            height: 40,

            decoration: BoxDecoration(),
            margin: const EdgeInsets.fromLTRB(
                35, 25, 35, 35), // Espaciado alrededor del botón
            child: ElevatedButton(
              onPressed: enviar == "ENVIAR"
                  ? null
                  : () => {VerificarEmail(_txtController.text, user["email"])},
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Bordes redondeados
                  ),
                  backgroundColor: Color.fromRGBO(1, 72, 179, 1)),
              child: const Text(
                'VERIFICAR',
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

  String getCounterString() {
    return ((counter > 0) ? "($counter)" : '');
  }

  Future<void> EnviarEmail(String destinatario) async {
    HttpGetRequest httpRequest = HttpGetRequest();

    GenericDialog dialogCredencialesIncorrectas = GenericDialog(
      titulo: "Error de conexion",
      cuerpo: "Por favor revise su conexion a internet y vuelva a intentarlo",
      icono: Icons.signal_wifi_bad_rounded,
      buttonTexto: "Cerrar",
    );
    dialogCredencialesIncorrectas.setButtonAction(
      () {
        Navigator.of(dialogCredencialesIncorrectas.getContext()).pop();
      },
    );

    final url = Uri.parse(
        'http://34.171.18.250:8080/api/email/'); // Reemplaza con tu URL de API

    String jsonData = '{"destinatario": "$destinatario"}';
    String? response = await httpRequest.httpPost(url, jsonData, '');

    if (response != 'error') {
      setState(() {
        enviar = "REENVIAR ";

        counter = 20;
      });
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

  Future<void> VerificarEmail(String codigo, String destinatario) async {
    if (codigo.isEmpty) {
      setState(() {
        _errorText = '*Este campo es obligatorio*';
      });
      return;
    } else {
      setState(() {
        _errorText = '';
      });
    }
    HttpGetRequest httpRequest = HttpGetRequest();

    GenericDialog dialogCredencialesIncorrectas = GenericDialog(
      titulo: "Error de conexion",
      cuerpo: "Por favor revise su conexion a internet y vuelva a intentarlo",
      icono: Icons.signal_wifi_bad_rounded,
      buttonTexto: "Cerrar",
    );
    dialogCredencialesIncorrectas.setButtonAction(
      () {
        Navigator.of(dialogCredencialesIncorrectas.getContext()).pop();
      },
    );

    String url =
        'http://34.171.18.250:8080/api/email/$codigo/$destinatario'; // Reemplaza con tu URL de API

    String? response = await httpRequest.fetchUrl(url);

    if (response != 'error') {
      final jsonResponse = json.decode(response!);
      if (jsonResponse["res"] == "ok") {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RestablecerScreen(user: user)));
      } else {
        setState(() {
          _errorText = 'El código ingresado no es válido';
        });
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
        margin: const EdgeInsets.only(bottom: 20),
        width: double.infinity,
        child: const Icon(
          Icons.verified,
          color: Color.fromARGB(255, 0, 0, 0),
          size: 70,
        ),
      ),
    );
  }

  Container cajasuperior(Size size) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(1, 72, 179, 1),
        Color.fromARGB(255, 100, 54, 131),
      ])),
      width: double.infinity,
      height: size.height * 0.4,
    );
  }
}
