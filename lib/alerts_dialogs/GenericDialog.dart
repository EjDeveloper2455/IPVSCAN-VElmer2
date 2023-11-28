import 'package:flutter/material.dart';

class GenericDialog extends StatelessWidget {
  final titulo;
  final icono;
  final cuerpo;
  final buttonTexto;
  var buttonAccion;
  var contexto;
  GenericDialog({
    super.key,
    required this.icono,
    required this.titulo,
    required this.cuerpo,
    required this.buttonTexto,
  });

  void setButtonAction(buttonAccion) {
    this.buttonAccion = buttonAccion;
  }

  BuildContext getContext() {
    return this.contexto;
  }

  @override
  Widget build(BuildContext context) {
    this.contexto = context;
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
                Column(
                  children: [
                    Text(
                      titulo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      //style: boldTextStyle(size: 18)
                    ),
                    SizedBox(height: 20),
                    Icon(
                      icono,
                      size: 48,
                      color: Colors.black45,
                    ),
                  ],
                )
              ],
            ),
            Text(
              cuerpo,
              //style: secondaryTextStyle(size: 14)),
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: buttonAccion,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: Text(
                    buttonTexto,
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
