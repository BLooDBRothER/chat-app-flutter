import 'dart:io';

import 'package:chat_app_firebase/widgets/image_picker_actions.dart';
import 'package:chat_app_firebase/widgets/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final _firestore = FirebaseFirestore.instance;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Profile();
  }
}

class _Profile extends State<Profile> {
  File? _pickedImage;
  String? _uploadedImageUrl;
  bool _isUploading = true;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    _fetchUserDetails();
    super.initState();
  }

  void _fetchUserDetails() async {
    final userDocument = await _firestore.collection("users").doc(user.uid).get();
    _toggleUploadingLoader(false);
    if(!userDocument.exists) return;

    setState(() {
      _uploadedImageUrl = userDocument.get("profileImage");
    });
  }

  void _closeBottomSheet() {
    Navigator.pop(context);
  }

  void _toggleUploadingLoader(bool loadingState) {
    setState(() {
      _isUploading = loadingState;
    });
  }

  void _setImage(XFile? pickedImage) async {
    if(pickedImage == null) {
      return;
    }

    _toggleUploadingLoader(true);
    _closeBottomSheet();

    final pickedImageFile = File(pickedImage.path);

    setState(() {
      _pickedImage = pickedImageFile;
    });

    String imageType = "jpg";

    final storageRef = FirebaseStorage.instance.ref().child("user_images").child("${user.uid}$imageType");
    await storageRef.putFile(pickedImageFile);
    final url = await storageRef.getDownloadURL();

    final userData = {
      "profileImage": url
    };
    
    await _firestore.collection("users").doc(user.uid).set(userData);
    
    _toggleUploadingLoader(false);
  }

  void _pickImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 250
    );
    _setImage(pickedImage);
  }

  void _captureFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 250
    );
    _setImage(pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    dynamic image;

    if(_pickedImage != null) {
      image = FileImage(_pickedImage!);
    }
    else if(_uploadedImageUrl != null) {
      image = NetworkImage(_uploadedImageUrl!);
    }

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          CircleAvatar(
            // foregroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
            foregroundImage: image,
            radius: 60,
          ),
          const SizedBox(height: 8,),
          TextButton.icon(
            onPressed: () {
              if(_isUploading) return;
              showModalBottomSheet(context: context, builder: (BuildContext ctx) => Wrap(children: [ImagePickerActions(pickFromGallery: _pickImageFromGallery, captureFromCamera: _captureFromCamera)]));
            }, 
            icon: _isUploading ? const Loader() : const Icon(Icons.edit, size: 15,), 
            label: const Text("Upload Profile Picture")
          )
        ],
      ),
    );
  }
}
