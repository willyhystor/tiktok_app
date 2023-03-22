import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const String keyCollection = 'users';
  static const String keyUid = 'uid';
  static const String keyUsername = 'username';
  static const String keyProfilePic = 'profile_pic';
  static const String keyEmail = 'email';

  String uid;
  String username;
  String profilePic;
  String email;

  UserModel({
    required this.uid,
    required this.username,
    required this.profilePic,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        keyUid: uid,
        keyUsername: username,
        keyProfilePic: profilePic,
        keyEmail: email,
      };

  static UserModel fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    final map = documentSnapshot.data() as Map<String, dynamic>;

    return UserModel(
      uid: map[keyUid],
      username: map[keyUsername],
      profilePic: map[keyProfilePic],
      email: map[keyEmail],
    );
  }
}
