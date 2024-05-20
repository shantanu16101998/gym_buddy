import 'package:flutter/material.dart';

class CustomText extends StatefulWidget {
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final String text;

  const CustomText(
      {super.key,
      required this.text,
      this.fontSize,
      this.fontWeight,
      this.color});

  const CustomText.bodyHeading(
      {super.key,
      required this.text,
      this.fontSize = 22,
      this.fontWeight = FontWeight.bold,
      this.color = const Color(0xff344054)});

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.text,
        style: TextStyle(
            color: widget.color,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight));
  }
}
