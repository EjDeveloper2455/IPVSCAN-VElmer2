import 'package:desing_ipscamv2/main.dart';
import 'package:flutter/material.dart';
import '../theme/color_schemes.g.dart';

class ContenidoConsulta extends StatelessWidget {
  final List<dynamic> json;
  ContenidoConsulta({super.key, required this.json});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: SetState(json: this.json),
    );
  }
}

class SetState extends StatefulWidget {
  final List<dynamic> json;
  SetState({super.key, required this.json});
  @override
  ContenidoConsultaState createState() =>
      ContenidoConsultaState(json: this.json);
}

class ContenidoConsultaState extends State {
  final List<dynamic> json;
  ContenidoConsultaState({required this.json});
  final lista = ["Item 1", "Item 2", "Item 3"];
  late PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 0.9);
  int currentPage = 0, pagina = 1;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  void initState() {
    super.initState();

    _pageController =
        PageController(initialPage: currentPage, viewportFraction: 0.9);

    _pageController.addListener(() {
      setState(() {
        pagina = (_pageController.page?.round() ?? 0) + 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      title: 'Contenido',
      home: Scaffold(
        body: Column(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                //color: Color.fromARGB(255, 4, 46, 73),
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 30, // Añade margen superior
                    left: 125,
                    child: Container(
                      width: 150,
                      height: 100,
                      child: ClipRect(
                        child: Container(
                          width: 150,
                          height: 100,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                //color:Theme.of(context).colorScheme.inversePrimary
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface
                                    .withOpacity(.2)
                                    .withOpacity(0.3), // Color de sombra
                                offset: const Offset(
                                    0, 40), // Desplazamiento de sombra
                                blurRadius: 6, // Radio de difuminado
                                spreadRadius: 2, // Extensión de sombra
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/bg_placa.png',
                            width: 150,
                            height: 150,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.all(8),
                        width: 50,
                        height: 50,
                        child: const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    top: 30,
                    child: Center(
                      child: Text(
                        '${getByKey("placa", 0)}',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                //color: Colors.white,
                color: Theme.of(context).colorScheme.background,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Tabla 1: Datos de Vehículo
                        _buildTable(
                            context,
                            'Datos de Vehículo',
                            [
                              _buildTableRow(
                                  'Placa', '${getByKey('placa', 0)}'),
                              _buildTableRow('Marca', '${getByKey('anio', 0)}'),
                              _buildTableRow(
                                  'Modelo', '${getByKey('marca', 0)}'),
                              _buildTableRow(
                                  'Color', '${getByKey('modelo', 0)}'),
                              _buildTableRow(
                                  'Motor', '${getByKey('color', 0)}'),
                              _buildTableRow(
                                  'VIN / Serie', '${getByKey('vin', 0)}'),
                            ],
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withOpacity(0.1)),
                        const SizedBox(height: 20),
                        Text('${pagina} / ${json.length}'),
                        AspectRatio(
                          aspectRatio: 0.95,
                          child: PageView.builder(
                              itemCount: json.length,
                              physics: const ClampingScrollPhysics(),
                              controller: _pageController,
                              itemBuilder: (context, index) {
                                return Column(children: <Widget>[
                                  Container(
                                    child: _buildTable(
                                        context,
                                        '${getByKey('financiera', index)}',
                                        [
                                          _buildTableRow('Identidad',
                                              '${getByKey('identidad', index)}'),
                                          _buildTableRow('Nombre Cliente',
                                              '${getByKey('nombrecliente', index)}'),
                                          _buildTableRow('No. Préstamo',
                                              '${getByKey('prestamoid', index)}'),
                                          _buildTableRow('Días de Capital',
                                              '${getByKey('diasdecapital', index)}'),
                                          _buildTableRow('Monto Adeudado',
                                              '${getByKey('montocapital', index)}'),
                                        ],
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error
                                            .withOpacity(0.1)),
                                  )
                                ]);
                              }),
                        )
                        // Tabla 2: Datos de Financiera
                        ,

                        const SizedBox(height: 20),
                        // Icono de contacto y texto de contacto
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.contact_phone),
                            SizedBox(width: 10),
                            Text('Contacto: +504 27820036'),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getByKey(String key, int index) {
    final jsonOne = json[index];
    return jsonOne[key];
  }

  Widget _buildTable(BuildContext context, String title, List<TableRow> rows,
      {Color? color}) {
    bool isEven = false;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            //color: Theme.of(context).colorScheme.inversePrimary,
            color: Theme.of(context).colorScheme.inverseSurface.withOpacity(.2),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableTitle(context, title),
          Table(
            border: TableBorder.symmetric(
              inside: const BorderSide(width: 1, color: Colors.transparent),
            ),
            children: rows.map((row) {
              isEven = !isEven;
              return TableRow(
                decoration: BoxDecoration(
                  color: isEven
                      ? color ??
                          Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : Theme.of(context).colorScheme.background,
                ),
                children: row.children,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTableTitle(BuildContext context, String title) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String title, String value) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(value), // Asigna el valor adecuado aquí
          ),
        ),
      ],
    );
  }
}
