import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:desing_ipscamv2/alerts_dialogs/DialogCredencialesIncorrectas.dart';
import 'package:desing_ipscamv2/alerts_dialogs/GenericDialog.dart';
import 'package:desing_ipscamv2/cod_utils/HttpGetRequest.dart';
import 'package:desing_ipscamv2/input_decoration.dart';
import 'package:desing_ipscamv2/login_screen.dart';
import 'package:desing_ipscamv2/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestablecerScreen extends StatelessWidget {
  final Map<String, dynamic> user;
  RestablecerScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        //systemNavigationBarColor: Theme.of(context).primaryColor,
      ),
      home: PantallaRestablecer(user: user),
    );
  }
}

class PantallaRestablecer extends StatefulWidget {
  final Map<String, dynamic> user;
  PantallaRestablecer({required this.user});
  @override
  // ignore: no_logic_in_create_state
  LoginState createState() => LoginState(user: user);
}

class LoginState extends State<PantallaRestablecer> {
  final Map<String, dynamic> user;
  LoginState({required this.user});
  bool obscureText = true;
  bool obscureText2 = true; // Inicialmente, la contraseña está oculta
  final TextEditingController _txtPassController = TextEditingController();
  final TextEditingController _txtPassController2 = TextEditingController();
  String _errorText = '';
  String _errorText2 = '';

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
          height: _errorText.isEmpty ? 500 : 520,
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
              'Cambiar contraseña',
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
                    obscureText: obscureText,
                    controller: _txtPassController,
                    decoration: InputDecorations.inputPassDecoration(
                      hintext: '******',
                      labeltext: 'Nueva Contraseña',
                      errorText: _errorText,
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
                  Padding(padding: EdgeInsets.all(10)),
                  TextFormField(
                    autocorrect: false,
                    obscureText: obscureText2,
                    controller: _txtPassController2,
                    decoration: InputDecorations.inputPassDecoration(
                      hintext: '******',
                      labeltext: 'Repetir Contraseña',
                      errorText: _errorText2,
                      icono: const Icon(Icons.lock_rounded),
                      iconEnd: IconButton(
                        icon: Icon(obscureText2
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obscureText2 =
                                !obscureText2; // Cambia el estado de la visibilidad de la contraseña
                          });
                        },
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
              onPressed: () => {
                CambiarPass(_txtPassController.text, _txtPassController2.text,
                    user["id"].toString())
              },
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

  Future<void> CambiarPass(String pass1, String pass2, String id) async {
    setState(() {
      _errorText = '';
      _errorText2 = '';
    });
    if (pass1.isEmpty) {
      setState(() {
        _errorText = '*Este campo es obligatorio*';
      });
      return;
    } else if (pass2.isEmpty) {
      setState(() {
        _errorText2 = '*Este campo es obligatorio*';
      });
      return;
    } else if (pass1.length < 8) {
      setState(() {
        _errorText2 = 'La contraseña debe contener\nmínimo 8 caracteres';
      });
    }
    if (pass1 != pass2) {
      setState(() {
        _errorText2 = 'Las contraseñas no coinciden';
      });
      return;
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

    final url = Uri.parse(
        'http://34.171.18.250:8080/api/user/restablecer/'); // Reemplaza con tu URL de API

    String jsonData = '{"id": "$id","password":"$pass1"}';
    String? response = await httpRequest.httpPut(url, jsonData, '');

    if (response != 'error') {
      final jsonResponse = json.decode(response!);
      // ignore: use_build_context_synchronously

      GenericDialog dialogIrInicio = GenericDialog(
        titulo: "Contraseña restablecida",
        cuerpo: "Se ha restablecido su contraseña exitosamente",
        icono: Icons.check,
        buttonTexto: "Ir a Login",
      );
      dialogIrInicio.setButtonAction(() async {
        await saveToCache('token', jsonResponse["token"]);
        Navigator.of(dialogIrInicio.getContext()).pop();
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialogIrInicio;
        },
      );
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
          Icons.password,
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
