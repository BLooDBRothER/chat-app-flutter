import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app_firebase/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = FirebaseFirestore.instance;

class UserProfileNotifier extends ChangeNotifier {
  late UserProfile? userProfile;
  bool isFetched = false;

  Future<void> fetchUserDetails() async {
    if(isFetched) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if(user == null){
     return;
    }

    final userDocument = await _firestore.collection("users").doc(user.uid).get();
    if(!userDocument.exists) return;

    String profileUrl = "";
    if(userDocument.data() != null && userDocument.data()!.containsKey("profileImage")){
      profileUrl = userDocument.get("profileImage");;
    }
    String username = userDocument.get("username");
    String email = userDocument.get("eamil");
    userProfile = UserProfile(user.uid, username, email, profileUrl);
    
    isFetched = true;

    notifyListeners();
  }

  Future<void> uploadProfilePic(File image) async {
    String imageType = "jpg";

    final storageRef = FirebaseStorage.instance.ref().child("user_images").child("${userProfile!.uid}$imageType");
    await storageRef.putFile(image);
    final url = await storageRef.getDownloadURL();

    final userData = {
      "profileImage": url
    };
    
    await _firestore.collection("users").doc(userProfile!.uid).set(userData, SetOptions(merge: true));

    userProfile!.profileUrl = url;

    notifyListeners();
  }
}

final userProfileProvider = ChangeNotifierProvider<UserProfileNotifier>((ref) => UserProfileNotifier());
