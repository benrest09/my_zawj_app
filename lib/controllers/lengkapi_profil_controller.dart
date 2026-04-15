import 'package:cloud_firestore/cloud_firestore.dart';

class LengkapiProfilController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> loadProfil(String uid) async {
    final doc = await _firestore.collection('profiles').doc(uid).get();

    if (doc.exists) {
      return doc.data();
    } else {
      return null;
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
    required String? akteCeraiPath,
  }) {
    if (namaLengkap.trim().isEmpty ||
        tanggalLahir.trim().isEmpty ||
        tempatLahir.trim().isEmpty ||
        domisili.trim().isEmpty ||
        pekerjaan.trim().isEmpty) {
      return 'Lengkapi data wajib terlebih dahulu';
    }

    if (!setujuTidakKomunikasi || !setujuSatuTaaruf || !setujuKebijakan) {
      return 'Centang semua persetujuan terlebih dahulu';
    }

    if ((statusNikah == 'Cerai Hidup' || statusNikah == 'Cerai Mati') &&
        (akteCeraiPath == null || akteCeraiPath.trim().isEmpty)) {
      return statusNikah == 'Cerai Hidup'
          ? 'Akte cerai wajib diupload'
          : 'Akte kematian wajib diupload';
    }

    return null;
  }

  Future<void> simpanProfil({
    required String uid,
    required Map<String, dynamic> dataProfil,
  }) async {
    final now = FieldValue.serverTimestamp();

    final dataSiapSimpan = {...dataProfil, 'uid': uid, 'updatedAt': now};

    final docRef = _firestore.collection('profiles').doc(uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        ...dataSiapSimpan,
        'createdAt': now,
        'isProfileComplete': true,
      });
    } else {
      await docRef.update(dataSiapSimpan);
    }
  }
}
