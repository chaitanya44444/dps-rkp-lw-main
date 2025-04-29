import 'package:lw/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  UserModel userModel =
      UserModel(email: "", uid: "", username: "", timestamp: DateTime.now(), interests: []);
  final userRef = FirebaseFirestore.instance.collection("users");

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return "Signed In";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        return "Wrong password provided for that user.";
      } else {
        print("${e.code}: ${e.toString()}");
        return "Something Went Wrong. ERROR: ${e.code}";
      }
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed Up";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        return "The account already exists for that email.";
      } else {
        print("${e.code}: ${e.toString()}");
        return "Something Went Wrong. ERROR: ${e.code}";
      }
    }
  }

  Future<void> addUserToDB(String uid, String username, String email, DateTime timestamp, List<String> interests) async {
    userModel = UserModel(uid: uid, username: username, email: email, timestamp: timestamp, interests: interests);

    await userRef.doc(uid).set(userModel.toJson());
  }

  Future<UserModel> getUserFromDB(String uid) async {
    final DocumentSnapshot doc = await userRef.doc(uid).get();

    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String signInWithGoogle() {
    try {
      _firebaseAuth.signInWithProvider(GoogleAuthProvider());
      return "12";
    } catch (error) {
      print(error);
      return "Something Went Wrong. ERROR: $error";
    }
  }
}
