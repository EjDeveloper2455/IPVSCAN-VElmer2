import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:desing_ipscamv2/ContenidoConsulta.dart';
import '../cod_utils/HttpGetRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialogGetInformation extends StatefulWidget {
  final String code;
  final BuildContext context;

  const DialogGetInformation(
      {super.key, required this.code, required this.context});

  @override
  DialogGetInformationState createState() => DialogGetInformationState();
}

class DialogGetInformationState extends State<DialogGetInformation>
    with SingleTickerProviderStateMixin {
  late AnimationController controllerAnimation;
  late bool isLoading = true;
  late bool sFoot = false;
  late bool sFoot2 = false;
  late String titulo;
  late String txtButton;
  late String inf;
  late int iconStateSelec;
  late bool noshow = true;

  List<IconData> iconState = [
    Icons.signal_wifi_bad_rounded,
    Icons.warning_amber_rounded,
    Icons.cloud_off_rounded,
    Icons.timer_off_outlined
  ];

  @override
  void initState() {
    super.initState();
    controllerAnimation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    titulo = 'Obteniendo información';
    txtButton = 'Cerrar';
    inf = 'Estamos obteniendo la información, por favor espere...';
    iconStateSelec = 0;

    getRequest();
  }

  void cambiarTitulo(String tit) {
    setState(() {
      titulo = tit;
    });
  }

  void cambiarInf(String info) {
    setState(() {
      inf = info;
    });
  }

  void cambiarIcon(int ic) {
    setState(() {
      iconStateSelec = ic;
    });
  }

  void mostrarFoot(bool sh) {
    setState(() {
      sFoot = sh;
      sFoot2 = false;
    });
  }

  void mostrarFoot2(bool sh) {
    try {
      setState(() {
        sFoot2 = sh;
        sFoot = false;
      });
    } catch (e) {}
  }

  void cambiarButtom(String value) {
    setState(() {
      txtButton = value;
    });
  }

  Future<void> showFoot2() async {
    await Future.delayed(const Duration(seconds: 5));
    if (noshow) {
      mostrarFoot2(true);
    }
  }

  Future<void> getRequest() async {
    try {
      HttpGetRequest httpRequest = HttpGetRequest();
      showFoot2();
      String placa = widget.code;
      placa = placa.substring(0, 3) + '-' + placa.substring(3, placa.length);
      String? token = await getFromCache("token");
      String? result = await httpRequest.httpPost(
          Uri.parse('http://placas.inversa.hn/sandbox/consulta/${placa}'),
          '',
          token!);
      if (result == null || result.isEmpty) {
        sendDialogo(
            "Error de conexion",
            "Fallo la conexion con el servidor, por favor verifique que se encuentre en linea.",
            2);
        noshow = false;
      } else {
        if (result.length == 1) {
          sendDialogo(
              "Tiempo de espera agotado",
              "Se agoto el tiempo de espera, es posible que su conexion a internet es lenta o el servidor tiene mucho trafico.",
              3);
          noshow = false;
        }
      }
      if (result != null) {
        analizarJson(result);
      }
    } catch (error) {
      if (error is SocketException) {
        print('Error de conexión: $error');
        // Manejar el error de conexión, por ejemplo, mostrar un mensaje al usuario
      } else {
        // Manejar otros tipos de errores
        print('Otro error: $error');
      }
    }
  }

  void sendDialogo(String tit, String info, int icono) {
    cambiarTitulo(tit);
    cambiarInf(info);
    cambiarIcon(icono);
    mostrarFoot(true);
    isLoading = false;
  }

  void analizarJson(String result) {
    try {
      Map<String, dynamic> json = jsonDecode(result);
      List<dynamic> arrayJson = json['data'];

      if (json['code'] != null) {
        sendDialogo(
            "Error de conexión",
            "Fallo a conexión con el servidor, por favor verifique que se encuentre en linea.",
            2);
        noshow = false;
        return;
      }
      if (json.isEmpty) {
        sendDialogo(
          "Datos no encontrados",
          "No se encontro el numero de placa ingresado.",
          1,
        );
        noshow = false;
      } else {
        if (arrayJson.length > 0) {
          Navigator.of(context).pop(); // Cierro el dialog
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContenidoConsulta(json: arrayJson),
            ),
          );
        } else {
          sendDialogo(
            "Datos no encontrados",
            "No se encontro el numero de placa ingresado.",
            1,
          );
        }
      }
    } catch (e) {
      sendDialogo(
        "Datos no encontrados",
        "No se encontro el numero de placa ingresado.",
        1,
      );
      noshow = false;
    }
  }

  Future<String?> getFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString(key));
    return prefs.getString(key);
  }

  @override
  void dispose() {
    controllerAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Evita que se cierre al tocar fuera
      },
      child: Dialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(.2),
                blurRadius: 10.0,
                offset: const Offset(0.0, 0.0),
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        titulo,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnimatedBuilder(
                        animation: controllerAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: controllerAnimation.value *
                                2 *
                                3.1415926535897932,
                            child: Visibility(
                              visible: isLoading,
                              child: Image.asset(
                                'assets/images/loading.png',
                                width: 48,
                                height: 48,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          );
                        },
                      ),
                      Visibility(
                        visible: !isLoading,
                        child: Icon(
                          iconState[iconStateSelec],
                          size: 48,
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                      )
                    ],
                  )
                ],
              ),
              Text(
                inf,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: sFoot,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: Text(
                        txtButton,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: sFoot2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'El servidor está tardando más de lo normal en responder, puede cancelar la búsqueda o esperar que finalice.',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                        height: 10), // Espaciado entre el texto y el botón
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
