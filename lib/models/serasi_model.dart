import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
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
      'userId': userId,
      'namaLengkap': namaLengkap,
      'jenisKelamin': jenisKelamin,
      'usia': usia,
      'domisili': domisili,
      'pendidikan': pendidikan,
      'pekerjaan': pekerjaan,
      'tentangSaya': tentangSaya,
      'fotoProfil': fotoProfil,
    };
  }

  factory SerasiModel.fromMap(Map<String, dynamic> map) {
    return SerasiModel(
      userId: map['userId'] as int,
      namaLengkap: map['namaLengkap'] as String,
      jenisKelamin: map['jenisKelamin'] as String,
      usia: map['usia'] as int,
      domisili: map['domisili'] as String,
      pendidikan: map['pendidikan'] as String,
      pekerjaan: map['pekerjaan'] as String,
      tentangSaya: map['tentangSaya'] as String,
      fotoProfil: map['fotoProfil'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SerasiModel.fromJson(String source) =>
      SerasiModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
