import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String uid;
  String username;
  List<String> interests;
  DateTime timestamp;

  UserModel(
      {required this.email,
      required this.uid,
      required this.username,
      required this.timestamp,
      required this.interests});

  Map<String, dynamic> toMap(UserModel user) {
    var data = <String, dynamic>{};

    data["uid"] = user.uid;
    data["username"] = user.username;
    data["email"] = user.email;
    data["timestamp"] = user.timestamp;
    data["interests"] = user.interests;

    return data;
  }

  UserModel.fromMap(Map<String, dynamic> mapData)
    :this(
    uid: mapData["uid"] as String,
    username: mapData["username"] as String,
    email: mapData["email"] as String,
    timestamp: (mapData["timestamp"] as Timestamp).toDate(),
    interests: mapData["interests"] as List<String>
  );
}
