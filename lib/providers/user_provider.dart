import 'dart:io';
import 'dart:developer';

import 'package:chat_app_firebase/service/notification/firebase_message_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app_firebase/models/user_profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = FirebaseFirestore.instance;

class UserProfileNotifier extends ChangeNotifier {
  late UserProfile? userProfile;
  bool isFetched = false;

  Future<void> fetchUserDetails() async {
    if (isFetched) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final userDocument =
        await _firestore.collection("users").doc(user.uid).get();
    if (!userDocument.exists) return;
    userProfile = UserProfile.fromSnapshot(user.uid, userDocument.data()!);

    if(!userDocument.data()!.containsKey("fcmToken") || userDocument.get("fcmToken") != FirebaseMessageApi.fcmToken) {
      updateUserFcmToken(FirebaseMessageApi.fcmToken!, user.uid);
    }

    isFetched = true;

    initUserTokenUpdate();

    notifyListeners();
  }

  Future<void> uploadProfilePic(File image) async {
    String imageType = "jpg";

    final storageRef = FirebaseStorage.instance
        .ref()
        .child("user_images")
        .child("${userProfile!.uid}$imageType");
    await storageRef.putFile(image);
    final url = await storageRef.getDownloadURL();

    final userData = {"profileImage": url};

    await _firestore
        .collection("users")
        .doc(userProfile!.uid)
        .set(userData, SetOptions(merge: true));

    userProfile!.profileUrl = url;

    notifyListeners();
  }

  void initUserTokenUpdate() {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      updateUserFcmToken(fcmToken, userProfile!.uid);
    }).onError((err) {
      log("Error on Token Refresh", name: "FCM Token", time: DateTime.timestamp());
    });
  }

  Future<void> updateUserFcmToken(String fcmToken, String uid) async {
    final fcmData = {
      "fcmToken": fcmToken
    };
    await _firestore
        .collection("users")
        .doc(uid)
        .set(fcmData, SetOptions(merge: true));
  }

  void clearUsers() {
    isFetched = false;
    userProfile = null;
  }
}

final userProfileProvider =
    ChangeNotifierProvider<UserProfileNotifier>((ref) => UserProfileNotifier());
