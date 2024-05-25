import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class CustomImagePicker extends StatefulWidget {
  const CustomImagePicker({super.key});

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  late ImagePicker _picker;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    final sharedPreferences = await SharedPreferences.getInstance();

    if (pickedFile != null) {
      var base64file = base64Encode(await pickedFile.readAsBytes());

        print(base64file);

      setState(() {
        _imageFile = pickedFile;
        sharedPreferences.setString("profilePic", base64file);
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
        final sharedPreferences = await SharedPreferences.getInstance();

        var base64file =
            base64Encode(await XFile(croppedFile.path).readAsBytes());

        print(base64file);

        sharedPreferences.setString("profilePic", base64file);

        setState(() {
          _imageFile = XFile(croppedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
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
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey[200],
              backgroundImage:
                  _imageFile != null ? FileImage(File(_imageFile!.path)) : null,
              child: _imageFile == null
                  ? const Icon(
                      Icons.add_a_photo,
                      size: 40,
                      color: Colors.grey,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0, backgroundColor: const Color(0xFFD9D9D9)),
            onPressed: _cropImage,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: CustomText(
                fontWeight: FontWeight.bold,
                text: 'Crop Image',
                fontSize: 18,
                color: Color(0xff004576),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
