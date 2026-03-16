import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class InboxModel {
  final int id;
  final int pengajuId;
  final int targetId;
  final String status;
  final String pesanPengajuan;
  final String? createdAt;

  final String namaLengkap;
  final String jenisKelamin;
  final int usia;
  final String domisili;
  final String? fotoProfil;
  final String pendidikan;
  final String pekerjaan;

  InboxModel({
    required this.id,
    required this.pengajuId,
    required this.targetId,
    required this.status,
    required this.pesanPengajuan,
    this.createdAt,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.usia,
    required this.domisili,
    this.fotoProfil,
    required this.pendidikan,
    required this.pekerjaan,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pengajuId': pengajuId,
      'targetId': targetId,
      'status': status,
      'pesanPengajuan': pesanPengajuan,
      'createdAt': createdAt,
      'namaLengkap': namaLengkap,
      'jenisKelamin': jenisKelamin,
      'usia': usia,
      'domisili': domisili,
      'fotoProfil': fotoProfil,
      'pendidikan': pendidikan,
      'pekerjaan': pekerjaan,
    };
  }

  factory InboxModel.fromMap(Map<String, dynamic> map) {
    return InboxModel(
      id: map['id'] as int,
      pengajuId: map['pengajuId'] as int,
      targetId: map['targetId'] as int,
      status: map['status'] as String,
      pesanPengajuan: map['pesanPengajuan'] as String,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      namaLengkap: map['namaLengkap'] as String,
      jenisKelamin: map['jenisKelamin'] as String,
      usia: map['usia'] as int,
      domisili: map['domisili'] as String,
      fotoProfil: map['fotoProfil'] != null
          ? map['fotoProfil'] as String
          : null,
      pendidikan: map['pendidikan'] as String,
      pekerjaan: map['pekerjaan'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InboxModel.fromJson(String source) =>
      InboxModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
