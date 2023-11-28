import 'package:flutter/material.dart';
import 'cod_utils/HttpGetRequest.dart';
import 'theme/color_schemes.g.dart';
import 'dart:convert';

class historial extends StatefulWidget {
  historial({Key? key}) : super(key: key);

  @override
  State<historial> createState() => _historialState();
}

class _historialState extends State<historial> {
  List _listarRegistro = [Registro("MAT1234", "08-09-2023 12:00:00")];

  @override
  void initState() {
    super.initState();
    getRequest();
  }

  Future<void> getRequest() async {
    HttpGetRequest httpRequest = HttpGetRequest();
    String url = 'http://34.125.252.26:8080/api/registro/1';
    String? result = await httpRequest.fetchUrl(url);
    if (result == null || result.isEmpty) {
    } else {
      analizar_jSon(result);
    }
  }

  void analizar_jSon(String result) {
    try {
      List<dynamic> apexItems = json.decode(result);

      if (apexItems.isNotEmpty) {
        setState(() {
          apexItems.forEach((jsonData) {
            _listarRegistro.add(Registro(jsonData["placa"], jsonData["fecha"]));
          });
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                Center(
                  child: Text(
                    'Historial',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                            hintText: 'Buscar en historial',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listarRegistro.length,
              itemBuilder: (BuildContext context, int index) {
                final log = _listarRegistro[index];
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 253, 253, 253),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  child: ListTile(
                    title: Text(log.placa),
                    subtitle: Text(log.fecha),
                    leading: Image.asset(
                      'assets/images/historial1.png',
                      width: 50,
                      height: 50,
                    ),
                    trailing: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: IconButton(
                        onPressed: () async {},
                        icon: const Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Registro {
  late String placa;
  late String fecha;

  Registro(this.placa, this.fecha);
}
