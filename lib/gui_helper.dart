import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void showNotify(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

Widget loadingCircle() {
  return Center(
    child: LoadingAnimationWidget.discreteCircle(color: Colors.cyan, size: 100),
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

InputDecoration roundInputDecoration(String label, String hintText) {
  return InputDecoration(
    label: Text(label),
    hintText: hintText,
    contentPadding: const EdgeInsetsDirectional.only(
      start: 25,
      top: 15,
      bottom: 15,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(35),
    ),
    hoverColor: null,
  );
}
