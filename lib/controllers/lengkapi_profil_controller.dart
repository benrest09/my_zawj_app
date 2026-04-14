import 'package:zawj_app/database/sqflite.dart';

class LengkapiProfilController {
  Future<Map<String, dynamic>?> loadProfil(int userId) async {
    return await DBHelper.getProfileByUserId(userId);
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
    required int userId,
    required Map<String, dynamic> dataProfil,
  }) async {
    final profilLama = await DBHelper.getProfileByUserId(userId);
    final now = DateTime.now().toIso8601String();

    final dataSiapSimpan = {
      ...dataProfil,
      'user_id': userId,
      'jenis_kelamin': DBHelper.normalisasiJenisKelamin(
        dataProfil['jenis_kelamin']?.toString() ?? '',
      ),
      'updated_at': now,
    };

    if (profilLama == null) {
      await DBHelper.createProfile({...dataSiapSimpan, 'created_at': now});
    } else {
      await DBHelper.updateProfile(userId, dataSiapSimpan);
    }
  }
}
