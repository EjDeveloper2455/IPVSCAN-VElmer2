import 'package:desing_ipscamv2/login_screen.dart';
import 'package:desing_ipscamv2/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/color_schemes.g.dart';

class PantallaCargando extends StatefulWidget {
  @override
  State<PantallaCargando> createState() => cargandoState();
}

class cargandoState extends State<PantallaCargando>
    with SingleTickerProviderStateMixin {
  late AnimationController controllerAnimation;

  @override
  void initState() {
    super.initState();

    controllerAnimation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) => cambiarPantalla());
  }

  Future<void> cambiarPantalla() async {
    bool? verificar = await verificarCredenciales();
    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                verificar == true ? HomePage() : const LoginScreen()));
  }

  Future<bool?> verificarCredenciales() async {
    String? credentialCache = await getFromCache('token');
    if (credentialCache != null && !credentialCache.isEmpty) return true;
    return false;
  }

// Recuperar datos en caché
  Future<String?> getFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString(key));
    return prefs.getString(key);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      title: 'Inicio',
      home: Scaffold(
          body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Stack(children: <Widget>[
              Image.asset(
                'assets/images/conectando.png',
                width: 400,
                height: 150,
              ),
              Positioned(
                top: 25.0, // Ajusta la posición según sea necesario
                left: 149.0, // Ajusta la posición según sea necesario
                child: AnimatedBuilder(
                  animation: controllerAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: controllerAnimation.value * 2 * 3.1415926535897932,
                      child: Visibility(
                        visible: true,
                        child: Image.asset(
                          'assets/images/loading.png',
                          width: 55,
                          height: 55,
                          color: Color.fromRGBO(3, 155, 234, 1),
                        ),
                      ),
                    );
                  },
                ),
              )
            ]),
            const SizedBox(height: 30),
            const Text(
              "Conectando con el servidor...",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(3, 155, 234, 1),
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      )),
    );
  }
}
