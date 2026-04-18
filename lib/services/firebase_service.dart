import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zawj_app/models/user_model_firebase.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Random _random = Random();

  /// REGISTER
  static Future<(UserModelFirebase?, String?)> registerUser({
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
      if (user == null) return (null, 'User gagal dibuat');

      final userModel = UserModelFirebase(
        id: user.uid,
        nama: username,
        email: email,
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

      return (userModel, null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return (null, 'Email sudah terdaftar');
      } else if (e.code == 'weak-password') {
        return (null, 'Password terlalu lemah');
      }
      return (null, e.message);
    } catch (e) {
      return (null, 'Terjadi kesalahan');
    }
  }

  /// LOGIN
  static Future<(UserModelFirebase?, String?)> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user == null) return (null, 'User tidak ditemukan');

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) return (null, 'Data user tidak ditemukan');

      return (UserModelFirebase.fromMap(doc.data()!, doc.id), null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return (null, 'Email tidak terdaftar');
      } else if (e.code == 'wrong-password') {
        return (null, 'Password salah');
      }
      return (null, e.message);
    } catch (e) {
      return (null, 'Terjadi kesalahan');
    }
  }

  /// LOGOUT
  static Future<void> logout() async {
    await _auth.signOut();
  }

  /// GET CURRENT USER
  static Future<UserModelFirebase?> getUserById(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModelFirebase.fromMap(doc.data()!, doc.id);
  }

  static Future<UserModelFirebase?> getRandomUstadz() async {
    final query = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'ustadz')
        .get();

    if (query.docs.isEmpty) return null;

    final doc = query.docs[_random.nextInt(query.docs.length)];
    return UserModelFirebase.fromMap(doc.data(), doc.id);
  }

  ///USER UPLOAD GAMBAR
  static Future<String?> uploadFile({
    required String filePath,
    required String uid,
    required String fileName,
  }) async {
    try {
      if (filePath.isEmpty) return null;

      final file = File(filePath);

      final ref = FirebaseStorage.instance.ref().child(
        'profiles/$uid/$fileName',
      );

      await ref.putFile(file);

      final url = await ref.getDownloadURL();

      return url;
    } catch (e) {
      print("ERROR UPLOAD: $e");
      return null;
    }
  }
}
