import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:gym_buddy/providers/subscription_provider.dart';

class ImageDialog extends StatefulWidget {
  final ImageProvider<Object> image;
  final Function changeImage;
  final String customerId;

  const ImageDialog(
      {super.key,
      required this.image,
      required this.changeImage,
      required this.customerId});

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  late ImagePicker _picker;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _cropImage() async {
    if (_imageFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 1000,
        maxHeight: 1000,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor:
                const Color.fromARGB(255, 85, 84, 84).withOpacity(0.98),
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor:
                const Color.fromARGB(255, 85, 84, 84).withOpacity(0.98),
            initAspectRatio: CropAspectRatioPreset.original,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _imageFile = XFile(croppedFile.path);
        });
      }
    }
  }

  void _uploadImage() async {
    if (_imageFile != null) {
      await uploadImage('/aws/upload', _imageFile!, widget.customerId);
    }

    if (mounted) {
      await Provider.of<SubscriptionProvider>(context, listen: false)
          .fetchSubscription();
    }

    widget.changeImage(Image.file(File(_imageFile!.path)).image);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                image: DecorationImage(
                    image: _imageFile == null
                        ? widget.image
                        : Image.file(File(_imageFile!.path)).image,
                    fit: BoxFit.cover)),
          ),
          Container(
            color: Colors.white,
            width: double.infinity,
            child: Column(
              children: [
                _imageFile != null
                    ? TextButton(
                        onPressed: _cropImage,
                        child: const CustomText(
                            text: "Crop Picture",
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 22),
                      )
                    : const SizedBox(),
                _imageFile == null
                    ? TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.blue,
                                title: const Text('Choose an option'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text('Pick from gallery'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _pickImage(ImageSource.gallery);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text('Take a photo'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _pickImage(ImageSource.camera);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const CustomText(
                            text: "Edit Picture",
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 22))
                    : TextButton(
                        onPressed: _uploadImage,
                        child: const CustomText(
                            text: "Upload",
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 22)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
