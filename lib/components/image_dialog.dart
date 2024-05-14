import 'package:flutter/material.dart';
import 'package:gym_buddy/components/custom_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

class ImageDialog extends StatefulWidget {
  final ImageProvider<Object> image;
  final Function changeImage;

  const ImageDialog(
      {super.key, required this.image, required this.changeImage});

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

  void _uploadImage() {
    widget.changeImage(Image.file(File(_imageFile!.path)).image);
    Navigator.pop(context);
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
                    : SizedBox(),
                _imageFile == null
                    ? TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
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
