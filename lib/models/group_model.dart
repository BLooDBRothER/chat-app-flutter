class GroupRequestModel {
  final String id;
  final String name;
  final String description;
  final String? profileImage;

  GroupRequestModel(this.id, this.name, this.description, this.profileImage);

  factory GroupRequestModel.fromSnapshot(String id, Map<String, dynamic> snapshot) {
    final name = snapshot["name"];
    final description = snapshot["description"];
    final profileImage = snapshot["profileImage"];

    return GroupRequestModel(id, name, description, profileImage);
  }
}