import 'dart:io';

import 'package:chat_app_firebase/widgets/image_picker_actions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Profile();
  }
}

class _Profile extends State<Profile> {
  File? _pickedImage;

  void _setImage(XFile? pickedImage) async {
    if(pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImage = File(pickedImage.path);
    });
    Navigator.pop(context);
  }

  void _pickImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 150
    );
    _setImage(pickedImage);
  }

  void _captureFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 150
    );
    _setImage(pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          CircleAvatar(
            foregroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
            radius: 60,
          ),
          const SizedBox(height: 8,),
          TextButton.icon(
            onPressed: () {
              showModalBottomSheet(context: context, builder: (BuildContext ctx) => Wrap(children: [ImagePickerActions(pickFromGallery: _pickImageFromGallery, captureFromCamera: _captureFromCamera)]));
            }, 
            icon: const Icon(Icons.edit, size: 15,), 
            label: const Text("Upload Profile Picture")
          )
        ],
      ),
    );
  }
}
