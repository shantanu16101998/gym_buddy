import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// This is the screen that you'll see when the app starts
class QrCodePic extends StatefulWidget {
  @override
  State<QrCodePic> createState() => _QrCodePic();
  final Color? qrColor;
  final String upiIntentLink;
  const QrCodePic({super.key, required this.qrColor,required this.upiIntentLink});
}

class _QrCodePic extends State<QrCodePic> {
  @override
  Widget build(BuildContext context) {

    final FutureBuilder<ui.Image> qrFutureBuilder = FutureBuilder<ui.Image>(
      future: _loadOverlayImage(),
      builder: (BuildContext ctx, AsyncSnapshot<ui.Image> snapshot) {
        const double size = 200.0;
        if (!snapshot.hasData) {
          return const SizedBox(width: size, height: size);
        }
        return CustomPaint(
          size: const Size.square(size),
          painter: QrPainter(
            data: widget.upiIntentLink,
            version: QrVersions.auto,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: widget.qrColor,
            ),
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.circle,
              color: widget.qrColor,
            ),
            // size: 320.0,
          ),
        );
      },
    );

    // return Container(

    return Container(
      child: qrFutureBuilder,
    );
  }

  Future<ui.Image> _loadOverlayImage() async {
    final Completer<ui.Image> completer = Completer<ui.Image>();
    final ByteData byteData =
        await rootBundle.load('assets/images/profile_pic.png');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }
}
