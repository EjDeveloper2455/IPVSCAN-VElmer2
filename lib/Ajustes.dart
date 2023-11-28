import 'package:flutter/material.dart';

// Esta función principal se ejecuta al iniciar la aplicación.
void main() => runApp(const Ajustes());

class Ajustes extends StatefulWidget {
  const Ajustes({Key? key}) : super(key: key);

  @override
  _AjustesState createState() => _AjustesState();
}

// Clase principal que representa la pantalla de "Ajustes".
class _AjustesState extends State<Ajustes> {
  Locale _currentLocale = Locale('es'); // Establece el idioma predeterminado

  void _changeLanguage(Locale newLocale) {
    setState(() {
      _currentLocale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    // MaterialApp configura la aplicación Flutter.
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de depuración.
      title: 'Ajustes', // Título de la aplicación.
      supportedLocales: [
        const Locale('es', 'ES'),
        const Locale('en', 'US'),
      ],
      locale: _currentLocale,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              BlueHeader(), // Muestra el encabezado azul con información de usuario.
              const SizedBox(height: 16), // Espacio en blanco vertical.
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Muestra una tarjeta personalizada para seleccionar el idioma.
                      CustomCard(
                        title: 'Idioma', // Título de la tarjeta.
                        subtitle:
                            'Seleccione el idioma que desea', // Subtítulo de la tarjeta.
                        content: MyHomePage(
                            changeLanguage:
                                _changeLanguage), // Contenido de la tarjeta.
                        icon: Icons
                            .language, // Ícono personalizado para la tarjeta.
                      ),
                      SizedBox(height: 16), // Espacio en blanco vertical.
                      // Muestra una tarjeta personalizada para activar el tema oscuro.
                      CustomCard(
                        title: 'Tema Oscuro', // Título de la tarjeta.
                        subtitle:
                            'Seleccione para cambiar a tema oscuro', // Subtítulo de la tarjeta.
                        content: ThemeSwitcher(), // Contenido de la tarjeta.
                      ),
                      SizedBox(height: 16), // Espacio en blanco vertical.
                      // Muestra una tarjeta personalizada para cerrar la sesión.
                      CustomCard(
                        title: 'Sesión', // Título de la tarjeta.
                        subtitle:
                            'Salir de la Aplicación', // Subtítulo de la tarjeta.
                        content: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Lógica para cerrar sesión (aún por implementar).
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red, // Color de fondo del botón.
                              onPrimary:
                                  Colors.white, // Color del texto del botón.
                            ),
                            child: Text('Cerrar Sesión'), // Texto del botón.
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget personalizado que muestra el encabezado azul con información de usuario.
class BlueHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Nombre del Usuario',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Correo del Usuario',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget personalizado que crea tarjetas personalizadas con título, subtítulo, contenido y un ícono opcional.
class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget content;
  final IconData? icon; // Icono personalizado opcional.

  const CustomCard({
    required this.title,
    required this.subtitle,
    required this.content,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }
}

// Widget personalizado que muestra un menú desplegable para seleccionar el idioma.
class MyHomePage extends StatelessWidget {
  final Function(Locale) changeLanguage;

  MyHomePage({required this.changeLanguage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<Locale>(
              value: Localizations.localeOf(context),
              items: [
                DropdownMenuItem(
                  value: Locale('es', ''),
                  child: Row(
                    children: [
                      Icon(Icons.language), // Icono de idioma.
                      SizedBox(width: 8),
                      Text('Español'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: Locale('en', ''),
                  child: Row(
                    children: [
                      Icon(Icons.language), // Icono de idioma.
                      SizedBox(width: 8),
                      Text('English'),
                    ],
                  ),
                ),
              ],
              onChanged: (newLocale) {
                changeLanguage(newLocale!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownLanguagePicker extends StatefulWidget {
  @override
  _DropdownLanguagePickerState createState() => _DropdownLanguagePickerState();
}

class _DropdownLanguagePickerState extends State<DropdownLanguagePicker> {
  String selectedLanguage = 'Español'; // El idioma seleccionado por defecto.

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedLanguage,
      onChanged: (newValue) {
        setState(() {
          selectedLanguage = newValue!;
        });
      },
      items: <String>['Español', 'Inglés']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: [
              Icon(Icons.language), // Icono de idioma.
              SizedBox(width: 8),
              Text(value),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// Widget personalizado que muestra un interruptor para activar/desactivar el tema oscuro.
class ThemeSwitcher extends StatefulWidget {
  @override
  _ThemeSwitcherState createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  bool isDarkThemeEnabled = false; // Cambia esto para activar el tema oscuro.

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Aplicar tema oscuro',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18, // Tamaño igual al título.
            ),
          ),
        ),
        Switch(
          value: isDarkThemeEnabled,
          onChanged: (value) {
            setState(() {
              isDarkThemeEnabled = value;
            });
          },
        ),
      ],
    );
  }
}
