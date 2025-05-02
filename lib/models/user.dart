import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String uid;
  String username;
  List interests;
  DateTime timestamp;

  UserModel(
      {required this.email,
      required this.uid,
      required this.username,
      required this.timestamp,
      required this.interests});

  UserModel.fromJson(Map<String, Object?> json)
      : this(
          uid: json["uid"] as String,
          username: json["username"] as String,
          email: json["email"] as String,
          timestamp: (json["timestamp"] as Timestamp).toDate(),
          interests: json["interests"] as List
        );

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'timestamp': timestamp,
      'interests': interests
    };
  }
}
