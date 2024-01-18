import 'package:dropdown_search/dropdown_search.dart';
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
      ));
}

PopupProps roundPopupProps(String text) {
  return PopupProps.menu(
    title: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ),
    showSelectedItems: true,
  );
}
