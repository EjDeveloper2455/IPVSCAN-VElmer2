import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'cod_utils/InternetChecker.dart';
import 'cod_utils/image_picker_class.dart';
import 'cod_utils/image_cropper_page.dart';
import 'alerts_dialogs/DialogNotConnection.dart';
import 'alerts_dialogs/DialogGetInfomation.dart';
import 'alerts_dialogs/DialogSignOff.dart';
import 'cod_utils/FormatText.dart';
import '../theme/color_schemes.g.dart';

void main() {
  runApp(inicio());
}

class inicio extends StatelessWidget {
  late final BuildContext contexto2;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      title: 'Inicio',
      home: PantallaInicio(),
    );
  }
}

class PantallaInicio extends StatelessWidget {
  final TextEditingController _cod_placa = TextEditingController(text: '');
  late final BuildContext context_p;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 16), // Espacio a la izquierda
                        child: Center(
                          child: Text(
                            'Inicio',
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.account_circle),
                        color: Colors.white,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogSignOff();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              hintText: 'Numero de Placa',
                              border: OutlineInputBorder(),
                            ),
                            controller: _cod_placa,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () async {
                            if (!await InternetChecker.isInternetAvailable()) {
                              DialogNotConnection dialognoconnection =
                                  DialogNotConnection(
                                titulo: 'Sin conexión',
                                info:
                                    'No cuenta con una conexión a internet, por favor verifique el estado de la misma y vuelva a intentar.',
                                icono: 0,
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return dialognoconnection;
                                },
                              );
                            } else {
                              if (_cod_placa.text.isNotEmpty &&
                                  _cod_placa.text.trim().length == 7) {
                                getInformation(context, _cod_placa.text);
                              } else {
                                DialogNotConnection dialognoconnection =
                                    DialogNotConnection(
                                  titulo: 'Placa inválida',
                                  info:
                                      'El número de placa ingresado no es válido, ingrese un numero válido.',
                                  icono: 1,
                                );
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return dialognoconnection;
                                  },
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCard(
                  context,
                  Icons.photo_camera_back_outlined,
                  'Tome una fotografia de su vehiculo y escanee el código de la placa',
                  'Escanear Ahora',
                  () {
                    photoScam(context, 1);
                  },
                  iconColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  buttonColor: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 5),
                _buildCard(
                  context,
                  Icons.image_search,
                  'Seleccione una fotografia de su galeria y escanee el código de placa.',
                  'Buscar Ahora',
                  () {
                    photoScam(context, 2);
                  },
                  iconColor:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                  buttonColor: Theme.of(context).colorScheme.secondary,
                ),
                SizedBox(width: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getInformation(BuildContext context, String pCode) {
    DialogGetInformation dialogGetInformation = DialogGetInformation(
      code: pCode,
      context: context,
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialogGetInformation;
      },
    );
  }

  // Construye un Card personalizado
  Widget _buildCard(
    BuildContext context,
    IconData icon,
    String title,
    String buttonText,
    VoidCallback onPressed, {
    Color? iconColor,
    Color? buttonColor,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(context).colorScheme.inverseSurface.withOpacity(.2),
              blurRadius: 10, // Radio de desenfoque
              offset: Offset(0, 0), // Desplazamiento (x, y)
            ),
          ],
        ),
        //margin: EdgeInsets.only(left: (buttonText == "Escanear Ahora") ? 5 : 0,
        //    right: (buttonText == "Escanear Ahora") ? 0 : 5),
        child: Card(
          color: Theme.of(context).colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  icon,
                  size: 80,
                  color: iconColor ?? Color(0xFF3498db),
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor ?? Color(0xFF3498db),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    buttonText.replaceAll(" ", "\n"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void photoScam(BuildContext context, int i) {
    if (i == 1) {
      pickImage(source: ImageSource.camera).then((value) {
        if (value != '') {
          imageCropperView(value, context_p).then((value) {
            if (value != '') {
              final InputImage inputImage = InputImage.fromFilePath(value);
              processImage(context, inputImage);
            }
          });
        }
      });
    } else {
      pickImage(source: ImageSource.gallery).then((value) {
        if (value != '') {
          imageCropperView(value, context_p).then((value) {
            if (value != '') {
              final InputImage inputImage = InputImage.fromFilePath(value);
              processImage(context, inputImage);
            }
          });
        }
      });
    }
  }

  void processImage(BuildContext context, InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);

    CleanText formatText = CleanText(recognizedText.text, context_p);
    _cod_placa.text = formatText.getCleanText();
    if (_cod_placa.text.isNotEmpty) {
      getInformation(context, _cod_placa.text);
    }
  }
}
