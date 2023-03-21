class UserModel {
  final String username;
  final String email;
  final String profileImage;
  UserModel(
      {required this.username,
      required this.email,
      required this.profileImage});
  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'],
      email: map['email'],
      profileImage: map['profileImage'],
    );
  }
}
