import 'dart:developer';
import 'dart:io';

import 'package:chat_app_firebase/api/api_base.dart';
import 'package:chat_app_firebase/error/service_error.dart';
import 'package:chat_app_firebase/models/firestore_collections.dart';
import 'package:chat_app_firebase/models/user_profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

final _firestore = FirebaseFirestore.instance;
final _firebaseStorage = FirebaseStorage.instance;

Future<UserProfile> searchUser(String username) async {
  final users = await _firestore
      .collection(FirestoreCollections.users.name)
      .where("username", isEqualTo: username)
      .get();
  if (users.size == 0) {
    throw ServiceErrors.NO_USER_FOUND;
  }
  final user = users.docs[0];
  return UserProfile.fromSnapshot(user.id, user.data());
}

Future<String?> uploadGroupProfilePic(String uuid, File pickedImageFile) async {
  final storageRef =
      _firebaseStorage.ref().child("group_chat_images").child(uuid);
  await storageRef.putFile(pickedImageFile);
  final url = await storageRef.getDownloadURL();
  return url;
}

Future<void> createGroup(String groupId, Map<String, Object?> groupData) async {
  await _firestore.collection("groups").doc(groupId).set(groupData);
}

Future<void> sendCreateNotification(String groupId, String token) async {
  final res = await http.post(
    Uri.parse("$CREATE_GROUP_NOTIFICATION/$groupId"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': "Bearer $token"
    },
  );
  log("Create Group Notification Trigger Status - ${res.statusCode}", name: "Notification", time: DateTime.timestamp());
}