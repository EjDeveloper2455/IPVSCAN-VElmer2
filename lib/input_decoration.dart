import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration inputDecoration(
      {required String hintext,
      required String labeltext,
      required String errorText,
      required Icon icono}) {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue.shade700),
      ),
      errorText: errorText.isEmpty ? null : errorText,
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2)),
      hintText: hintext,
      labelText: labeltext,
      prefixIcon: icono,
    );
  }

  static InputDecoration inputPassDecoration(
      {required String hintext,
      required String labeltext,
      required Icon icono,
      required String errorText,
      required IconButton iconEnd}) {
    return InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade700),
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade700, width: 2)),
        hintText: hintext,
        errorText: errorText.isEmpty ? null : errorText,
        labelText: labeltext,
        prefixIcon: icono,
        suffixIcon: iconEnd);
  }
}
