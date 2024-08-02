class UserProfile {
  UserProfile(this.uid, this.username, this.email, this.profileUrl);

  String uid;
  String username;
  String email;
  String? profileUrl;

  factory UserProfile.fromSnapshot(String uid, Map<String, dynamic> snapshot) {
      final username = snapshot["username"];
      final email = snapshot["email"];
      final profileUrl = snapshot["profileImage"];

      return UserProfile(uid, username, email, profileUrl);
  }
  
}
