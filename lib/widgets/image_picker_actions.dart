import 'package:flutter/material.dart';

class ImagePickerActions extends StatelessWidget {
  const ImagePickerActions({
    super.key,
    required this.pickFromGallery,
    required this.captureFromCamera
  });

  final void Function() pickFromGallery;
  final void Function() captureFromCamera;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: pickFromGallery,
            child: const Column(
              children: [
                Icon(Icons.image),
                SizedBox(height: 8,),
                Text("Gallery")
              ],
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: captureFromCamera,
            child: const Column(
              children: [
                Icon(Icons.camera),
                SizedBox(height: 8,),
                Text("Camera")
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
