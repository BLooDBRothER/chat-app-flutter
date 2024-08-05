class UserProfile {
  UserProfile(this.uid, this.username, this.email, this.profileUrl, {this.userToken});

  String uid;
  String username;
  String email;
  String? profileUrl;
  String? userToken;

  factory UserProfile.fromSnapshot(String uid, Map<String, dynamic> snapshot, {String? token}) {
      final username = snapshot["username"];
      final email = snapshot["email"];
      final profileUrl = snapshot["profileImage"];

      return UserProfile(uid, username, email, profileUrl, userToken: token);
  }
  
}
