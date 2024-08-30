import 'dart:io';

import 'package:chat_app_firebase/widgets/image_picker_actions.dart';
import 'package:chat_app_firebase/widgets/loader.dart';
import 'package:chat_app_firebase/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() {
    return _Profile();
  }
}

class _Profile extends ConsumerState<Profile> {
  File? _pickedImage;
  bool _isUploading = false;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
  }

  void _closeBottomSheet() {
    Navigator.pop(context);
  }

  void _toggleUploadingLoader(bool loadingState) {
    if(mounted) {
      setState(() {
        _isUploading = loadingState;
      });
    }
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

    await ref.read(userProfileProvider).uploadProfilePic(pickedImageFile);

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
    final userProfile = ref.watch(userProfileProvider).getUser();

    dynamic image;

    if(_pickedImage != null) {
      image = FileImage(_pickedImage!);
    }
    else if(userProfile.profileUrl != null) {
      image = NetworkImage(userProfile.profileUrl!);
    }

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Center(
            child:
          Text(
            "Welcome ${userProfile.username} !",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          ),
          const SizedBox(height: 8,),
          CircleAvatar(
            foregroundImage: image,
            radius: 60,
            child: const Icon(Icons.person),
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
