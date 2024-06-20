import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatefulWidget {
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final String text;
  final bool? isUnderlined;
  final TextAlign? textAlign;

  const CustomText(
      {super.key,
      required this.text,
      this.fontSize,
      this.fontWeight,
      this.color,
      this.isUnderlined,
      this.textAlign});

  const CustomText.bodyHeading(
      {super.key,
      required this.text,
      this.fontSize = 22,
      this.fontWeight = FontWeight.bold,
      this.color = const Color(0xff344054),
      this.isUnderlined,
      this.textAlign});

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      textAlign: widget.textAlign,
      overflow: TextOverflow.clip,
      style: GoogleFonts.getFont(
        'Roboto',
          textStyle: TextStyle(
              color: widget.color,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
              decorationColor: widget.color,
              decoration: widget.isUnderlined == true
                  ? TextDecoration.underline
                  : null)),
    );
  }
}
