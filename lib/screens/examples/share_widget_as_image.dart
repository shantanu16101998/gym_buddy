import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gym_buddy/components/member/identity_card.dart';
import 'package:gym_buddy/components/common/app_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/services.dart' show rootBundle;

class ShareWidgetImage extends StatefulWidget {
  const ShareWidgetImage({super.key});

  @override
  _ShareWidgetImageState createState() => _ShareWidgetImageState();
}

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

class _ShareWidgetImageState extends State<ShareWidgetImage> {
  Future<void> _captureAndSharePng() async {
    ScreenshotController _screenshotController = ScreenshotController();

    _screenshotController
        .captureFromWidget(
      const // Provide a MediaQueryData object
      Directionality(
        textDirection: TextDirection.ltr,
        child: IdentityCard(
          profileUrl: '',
            dueDate: '24 March 2024',
            gymContact: '9319619778',
            gymName: 'Shantanu Gym',
            memberName: 'Suraj Kumar',
            validTillInMonths: '6'),
      ),
    )
        .then((Uint8List image) async {
      File file =
          await File('${(await getTemporaryDirectory()).path}/image.png')
              .create();
      file.writeAsBytesSync(image);

      Share.shareXFiles([XFile(file.path)], text: 'Great picture');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isApiDataLoaded: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _captureAndSharePng,
              child: const Text('Share Widget as Image'),
            ),
          ],
        ),
      ),
    );
  }
}
