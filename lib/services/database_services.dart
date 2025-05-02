import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lw/models/user.dart';

// Firebase Firestore

const String USERS_COLLECTION_REF = 'users';

class DatabaseService {
  final _firebase = FirebaseFirestore.instance;

  late final CollectionReference _userRefDefault= _firebase.collection(USERS_COLLECTION_REF);

  DatabaseService() {
    _userRefDefault.withConverter<UserModel>(
      fromFirestore: (snapshots, _) => UserModel.fromJson(
        snapshots.data()!,
      ),
    toFirestore: (user, _) => user.toJson());
  }

  Future<void> updateUserField(String uid, String field, dynamic value) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({field: value});
    } catch (e) {
      print('Error updating user field: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getSnapshotStream({String docId = "", String subCollection = "", String orderOn = "", bool descending = false}) {
    if (subCollection == "") {
      return _userRefDefault.snapshots();
    } else {
      return _userRefDefault.doc(docId).collection(subCollection).orderBy(orderOn, descending:false).snapshots();
    }
  }

  void addDoc(Map<String, Object?> data, {String docId = "", String subCollection = ""}) {
    if (subCollection != "") {
      _userRefDefault.doc(docId).collection(subCollection).add(data);
    } else {
      _userRefDefault.add(data);
    }
  }

  void updateDoc(String docId, Map<String, Object?> data, {String subCollection = "", String subDocId = ""}) {
    if (subCollection != "") {
      _userRefDefault.doc(docId).collection(subCollection).doc(subDocId).update(data);
    } else {
      _userRefDefault.doc(docId).update(data);
    }
  }

  void deleteDoc(String docId, {String subCollection = "", String subDocId = ""}) {
    if (subCollection != "") {
      _userRefDefault.doc(docId).collection(subCollection).doc(subDocId).delete();
    } else {
      _userRefDefault.doc(docId).delete();
    }
  }

  Future<DocumentSnapshot<Object?>> getDocSnapshot(String docId) {
    return _userRefDefault.doc(docId).get().then((value) => value);
  }
}
