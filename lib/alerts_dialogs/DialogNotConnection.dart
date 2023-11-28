import 'package:flutter/material.dart';

class DialogNotConnection extends StatefulWidget {
  final String titulo;
  final String info;
  final int icono;

  const DialogNotConnection({required this.titulo, super.key, required this.info, required this.icono});


  @override
  DialogNotConnectionState createState() => DialogNotConnectionState();


}

class DialogNotConnectionState extends State<DialogNotConnection>
    with SingleTickerProviderStateMixin {

  List<IconData> iconState = [
    Icons.signal_wifi_bad_rounded, //Sin conexion
    Icons.warning_amber_rounded, //Informacion no encontrada
  ];

  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Dialog(
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
              color: Theme.of(context).colorScheme.inverseSurface.withOpacity(.2),
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
                      widget.titulo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Icon(
                        iconState[int.parse('${widget.icono}')],
                        size: 48,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                  ],
                )
              ],
            ),
            Text(
              widget.info,
              style: const TextStyle(
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
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Text(
                      'Cerrar',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        //color: Colors.white,
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
