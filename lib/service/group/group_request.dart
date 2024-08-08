import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_firebase/api/api_base.dart';
import 'package:chat_app_firebase/models/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

final _firestore = FirebaseFirestore.instance;

Future<List<GroupRequestModel>> fetchGroupRequests(String userId) async {
  List<GroupRequestModel> groupRequests = [];
  final groupData = await _firestore
      .collection("groups")
      .where("pendingRequest", arrayContains: userId)
      .get();

  for (var group in groupData.docs) {
    groupRequests.add(GroupRequestModel.fromSnapshot(group.id, group.data()));
  }

  return groupRequests;
}

Future<void> acceptGroup(String groupId, String userId, String token) async {
  await _firestore
      .collection("groups")
      .doc(groupId)
      .update({
        "pendingRequest": FieldValue.arrayRemove([userId]),
        "users": FieldValue.arrayUnion([userId]),
        "updatedAt": FieldValue.serverTimestamp()
      });
  sendAcceptGroupNotification(groupId, userId, token);
}

Future<void> sendAcceptGroupNotification(String groupId, String userId, String token) async {
  final res = await http.post(
    Uri.parse("$ACCEPT_GROUP_NOTIFICATION/$groupId"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': "Bearer $token"
    },
    body: jsonEncode(<String, String> {
      "acceptedUserId": userId
    })
  );
  log("Accept Group Notification Trigger Status - ${res.statusCode}", name: "Notification", time: DateTime.timestamp());
}

Future<void> rejectGroup(String groupId, String userId) async {
  await _firestore
      .collection("groups")
      .doc(groupId)
      .update({
        "pendingRequest": FieldValue.arrayRemove([userId]),
        "updatedAt": FieldValue.serverTimestamp()
      });
}