import 'package:chat_app_firebase/models/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

Future<void> acceptGroup(String groupId, String userId) async {
  await _firestore
      .collection("groups")
      .doc(groupId)
      .update({
        "pendingRequest": FieldValue.arrayRemove([userId]),
        "users": FieldValue.arrayUnion([userId]),
        "updatedAt": FieldValue.serverTimestamp()
      });
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