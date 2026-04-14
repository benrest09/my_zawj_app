import 'dart:convert';

class SerasiModel {
  final int userId;
  final String namaLengkap;
  final String jenisKelamin;
  final int usia;
  final String domisili;
  final String pendidikan;
  final String pekerjaan;
  final String tentangSaya;
  final String? fotoProfil;

  SerasiModel({
    required this.userId,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.usia,
    required this.domisili,
    required this.pendidikan,
    required this.pekerjaan,
    required this.tentangSaya,
    required this.fotoProfil,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'nama_lengkap': namaLengkap,
      'jenis_kelamin': jenisKelamin,
      'usia': usia,
      'domisili': domisili,
      'pendidikan': pendidikan,
      'pekerjaan': pekerjaan,
      'tentang_saya': tentangSaya,
      'foto_profil': fotoProfil,
    };
  }

  factory SerasiModel.fromMap(Map<String, dynamic> map) {
    return SerasiModel(
      userId: map['user_id'] is int
          ? map['user_id'] as int
          : int.tryParse(map['user_id'].toString()) ?? 0,
      namaLengkap: map['nama_lengkap']?.toString() ?? '-',
      jenisKelamin: map['jenis_kelamin']?.toString() ?? '-',
      usia: map['usia'] is int
          ? map['usia'] as int
          : int.tryParse(map['usia']?.toString() ?? '0') ?? 0,
      domisili: map['domisili']?.toString() ?? '-',
      pendidikan: map['pendidikan']?.toString() ?? '-',
      pekerjaan: map['pekerjaan']?.toString() ?? '-',
      tentangSaya: map['tentang_saya']?.toString() ?? '-',
      fotoProfil: map['foto_profil']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SerasiModel.fromJson(String source) =>
      SerasiModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
