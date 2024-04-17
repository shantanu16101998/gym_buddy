import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  LabeledTextField({required this.labelText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(children: [
        TextField(
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
            decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white,fontSize: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  width: 1, color: Color.fromARGB(255, 255, 255, 255))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  width: 1, color: Color.fromARGB(255, 255, 255, 255))),
        ))
      ]),
    );
  }
}
