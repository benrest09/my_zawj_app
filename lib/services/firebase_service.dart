import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zawj_app/models/user_model_firebase.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static Future<UserModelFirebase?> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;

      if (user == null) return null;

      final userModel = UserModelFirebase(
        id: user.uid,
        nama: username,
        email: email,
      );

      await _firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      print('Register Error: ${e.message}');
      return null;
    } catch (e) {
      print('Register Error: $e');
      return null;
    }
  }

  static Future<UserModelFirebase?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;

      if (user == null) return null;

      final doc = await _firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) return null;

      return UserModelFirebase.fromMap(doc.data()!, doc.id);
    } on FirebaseAuthException catch (e) {
      print('Login Error: ${e.message}');
      return null;
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static Future<UserModelFirebase?> getCurrentUser() async {
    final user = _auth.currentUser;

    if (user == null) return null;

    final doc = await _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) return null;

    return UserModelFirebase.fromMap(doc.data()!, doc.id);
  }
}
