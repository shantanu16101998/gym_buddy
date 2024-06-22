import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';

class CustomDialogBox extends StatefulWidget {
  final Color buttonColor;
  final Widget iconWidget;
  final String heading;
  final String subheading;
  final Function()? buttonAction;
  final String? buttonName;
  final bool? shouldShowExtraDismissButton;
  const CustomDialogBox(
      {super.key,
      required this.buttonColor,
      required this.iconWidget,
      required this.heading,
      required this.subheading,
      this.buttonAction,
      this.buttonName,
      this.shouldShowExtraDismissButton});

  @override
  State<CustomDialogBox> createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 240,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            height: 200,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.iconWidget,
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomText(
                        text: widget.heading,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomText(
                        text: widget.subheading,
                        fontSize: 16,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if (widget.buttonAction != null) {
                      await widget.buttonAction!();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                        color: widget.buttonColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(
                                widget.shouldShowExtraDismissButton == true
                                    ? 0
                                    : 12))),
                    child: Center(
                        child: CustomText(
                      text: widget.buttonName != null
                          ? widget.buttonName!
                          : 'Dismiss',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                  ),
                ),
              ),
              if (widget.shouldShowExtraDismissButton == true)
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                        color: Color(0xffD3D3D3),
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(12))),
                    child: Center(
                        child: CustomText(
                      text: 'Dismiss',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
