import 'package:flutter/material.dart';

class DialogCredencialesIncorrectas extends StatelessWidget {
  const DialogCredencialesIncorrectas({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0)),
          ],
        ),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
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
                      )),
                ),
                const Column(
                  children: [
                    Text(
                      'Credenciales incorrectas',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      //style: boldTextStyle(size: 18)
                    ),
                    SizedBox(height: 20),
                    Icon(
                      Icons.error,
                      size: 48,
                      color: Colors.black45,
                    ),
                  ],
                )
              ],
            ),
            const Text(
              "Por favor verifica los campos ingresados y vuelve a intentarlo",
              //style: secondaryTextStyle(size: 14)),
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
