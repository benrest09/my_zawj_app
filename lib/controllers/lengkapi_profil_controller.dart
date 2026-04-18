import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zawj_app/models/profile_model.dart';

class LengkapiProfilController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ProfileModel?> loadProfil(String uid) async {
    try {
      final doc = await _firestore.collection('profiles').doc(uid).get();

      if (doc.exists) {
        return ProfileModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('ERROR LOAD PROFIL: $e');
      return null;
    }
  }

  Future<String?> loadNamaRegister(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;

      final nama = doc.data()?['nama']?.toString().trim();
      if (nama == null || nama.isEmpty) return null;

      return nama;
    } catch (e) {
      print('ERROR LOAD NAMA REGISTER: $e');
      return null;
    }
  }

  Stream<ProfileModel?> streamProfil(String uid) {
    return _firestore.collection('profiles').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return ProfileModel.fromMap(doc.data()!);
      }
      return null;
    });
  }

  Future<String?> simpanProfil({
    required String uid,
    required ProfileModel profile,
  }) async {
    try {
      final namaLengkapFix = profile.namaLengkap?.trim() ?? '';
      final now = FieldValue.serverTimestamp();
      final docRef = _firestore.collection('profiles').doc(uid);
      final doc = await docRef.get();

      await docRef.set({
        ...profile.toMap(),
        'namaLengkap': namaLengkapFix,
        'uid': uid,
        'updatedAt': now,
        if (!doc.exists) 'createdAt': now,
        'isProfileComplete': true,
      }, SetOptions(merge: true));

      if (namaLengkapFix.isNotEmpty) {
        await _firestore.collection('users').doc(uid).set({
          'nama': namaLengkapFix,
          'updatedAt': now,
        }, SetOptions(merge: true));
      }

      return null;
    } catch (e) {
      print('ERROR SIMPAN PROFIL: $e');
      return 'Gagal menyimpan profil';
    }
  }

  String? validasiProfil({
    required String namaLengkap,
    required String tanggalLahir,
    required String tempatLahir,
    required String domisili,
    required String pekerjaan,
    required bool setujuTidakKomunikasi,
    required bool setujuSatuTaaruf,
    required bool setujuKebijakan,
    required String statusNikah,
    String? akteCeraiPath,
  }) {
    if (namaLengkap.isEmpty) return "Nama lengkap wajib diisi";
    if (tanggalLahir.isEmpty) return "Tanggal lahir wajib diisi";
    if (tempatLahir.isEmpty) return "Tempat lahir wajib diisi";
    if (domisili.isEmpty) return "Domisili wajib diisi";
    if (pekerjaan.isEmpty) return "Pekerjaan wajib diisi";

    if (!setujuTidakKomunikasi) {
      return "Harus setuju tidak komunikasi di luar sistem";
    }

    if (!setujuSatuTaaruf) {
      return "Harus setuju satu taaruf satu waktu";
    }

    if (!setujuKebijakan) {
      return "Harus menyetujui kebijakan privasi";
    }

    if ((statusNikah == 'Cerai Hidup' || statusNikah == 'Cerai Mati') &&
        akteCeraiPath == null) {
      return "Akte cerai / kematian wajib diupload";
    }

    return null;
  }
}
