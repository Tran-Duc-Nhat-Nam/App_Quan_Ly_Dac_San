import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void showNotify(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

Widget loadingCircle({double size = 100}) {
  return Center(
    child:
        LoadingAnimationWidget.discreteCircle(color: Colors.cyan, size: size),
  );
}

ButtonStyle roundButtonStyle() {
  return const ButtonStyle(
    padding: MaterialStatePropertyAll(
      EdgeInsetsDirectional.symmetric(
        horizontal: 25,
        vertical: 20,
      ),
    ),
  );
}

InputDecoration roundInputDecoration(String label, String hintText,
    {double height = 25}) {
  return InputDecoration(
    label: Text(label),
    hintText: hintText,
    contentPadding: EdgeInsetsDirectional.only(
      start: 25,
      top: height / 2,
      bottom: height / 2,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(35),
    ),
    hoverColor: null,
  );
}

String? textFieldValidator(String? value, String notify) =>
    value == null || value.isEmpty ? notify : null;

InputDecoration roundSearchBarInputDecoration() {
  return const InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.white70),
      borderRadius: BorderRadius.all(
        Radius.circular(35),
      ),
    ),
    focusColor: Color.fromARGB(20, 65, 105, 225),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.white60),
      borderRadius: BorderRadius.all(
        Radius.circular(35),
      ),
    ),
    filled: true,
    fillColor: Color.fromARGB(20, 0, 114, 225),
    contentPadding: EdgeInsets.symmetric(horizontal: 25),
  );
}
