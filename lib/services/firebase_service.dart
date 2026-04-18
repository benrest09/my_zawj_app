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

      await user.updateDisplayName(username.trim());
      await user.reload();

      final userModel = await _syncUserDocument(
        uid: user.uid,
        email: email,
        nama: username,
      );

      return (userModel, null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return (null, 'Email sudah terdaftar');
      } else if (e.code == 'weak-password') {
        return (null, 'Password terlalu lemah');
      } else if (e.code == 'network-request-failed') {
        return (null, 'Koneksi internet bermasalah, coba lagi');
      }
      return (null, e.message ?? e.code);
    } catch (e) {
      return (null, e.toString());
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

      if (!doc.exists) {
        final userModel = await _syncUserDocument(
          uid: user.uid,
          email: user.email ?? email,
          nama: user.displayName ?? email.split('@').first,
        );
        return (userModel, null);
      }

      return (UserModelFirebase.fromMap(doc.data()!, doc.id), null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return (null, 'Email tidak terdaftar');
      } else if (e.code == 'wrong-password') {
        return (null, 'Password salah');
      } else if (e.code == 'network-request-failed') {
        return (null, 'Koneksi internet bermasalah, coba lagi');
      }
      return (null, e.message ?? e.code);
    } catch (e) {
      return (null, e.toString());
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

  static Future<UserModelFirebase> syncCurrentUserDocument() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User belum login');
    }

    return _syncUserDocument(
      uid: user.uid,
      email: user.email ?? '',
      nama: user.displayName ?? user.email?.split('@').first ?? 'User',
    );
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

  static Future<UserModelFirebase> _syncUserDocument({
    required String uid,
    required String email,
    required String nama,
  }) async {
    final docRef = _firestore.collection('users').doc(uid);
    final currentDoc = await docRef.get();
    final currentData = currentDoc.data() ?? {};

    final namaFix = nama.trim().isNotEmpty
        ? nama.trim()
        : (currentData['nama']?.toString() ?? 'User');
    final emailFix = email.trim().toLowerCase().isNotEmpty
        ? email.trim().toLowerCase()
        : (currentData['email']?.toString() ?? '');
    final roleFix = currentData['role']?.toString().isNotEmpty == true
        ? currentData['role'].toString()
        : 'user';

    final userModel = UserModelFirebase(
      id: uid,
      nama: namaFix,
      email: emailFix,
      role: roleFix,
    );

    await docRef.set({
      ...userModel.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
      if (!currentDoc.exists) 'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return userModel;
  }
}
