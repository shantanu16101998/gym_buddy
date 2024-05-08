import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LabeledTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final String? errorText;
  final bool shouldObscure;
  final Color textColour;
  final Color borderColor;
  final Color cursorColor;
  final void Function()? onTap;
  final void Function(String)? onChange;
  final Icon? prefixIcon;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? textInputFormatter;
  final bool? readOnly;

  const LabeledTextField.passwordField(
      {required this.labelText,
      required this.controller,
      required this.errorText,
      this.shouldObscure = true,
      this.textColour = Colors.white,
      this.borderColor = Colors.white,
      this.cursorColor = Colors.white,
      this.onTap,
      this.onChange,
      this.prefixIcon,
      this.textInputType,
      this.textInputFormatter,
      this.readOnly});

  const LabeledTextField(
      {super.key,
      required this.labelText,
      required this.controller,
      required this.errorText,
      this.shouldObscure = false,
      this.textColour = Colors.white,
      this.cursorColor = Colors.white,
      this.borderColor = Colors.white,
      this.onTap,
      this.onChange,
      this.prefixIcon,
      this.textInputType,
      this.textInputFormatter,
      this.readOnly});

  const LabeledTextField.homepageText(
      {super.key,
      required this.labelText,
      required this.controller,
      required this.errorText,
      this.shouldObscure = false,
      this.textColour = const Color(0xff667085),
      this.borderColor = const Color(0xffD0D5DD),
      this.cursorColor = const Color(0xff667085),
      this.onTap,
      this.onChange,
      this.prefixIcon,
      this.textInputType,
      this.textInputFormatter,
      this.readOnly});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(children: [
        TextFormField(
            readOnly: readOnly ?? false,
            style: TextStyle(color: textColour),
            cursorColor: cursorColor,
            controller: controller,
            onTap: onTap,
            inputFormatters: textInputFormatter,
            keyboardType: textInputType,
            onChanged: onChange,
            obscureText: shouldObscure,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              labelText: labelText,
              labelStyle: TextStyle(color: textColour, fontSize: 18),
              errorText: errorText,
              errorStyle: TextStyle(color: textColour),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      width: 1, color: borderColor.withOpacity(0.4))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(width: 1, color: borderColor)),
            ))
      ]),
    );
  }
}
