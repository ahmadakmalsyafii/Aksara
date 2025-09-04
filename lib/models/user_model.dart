class UserModel {
  final String uid;
  final String username;
  final String email;
  // final num streak;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      username: map['username'],
      email: map['email'],
    );
  }
}