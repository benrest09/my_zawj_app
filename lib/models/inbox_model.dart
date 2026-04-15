import 'package:cloud_firestore/cloud_firestore.dart';

class InboxModel {
  String id;
  String pengajuId;
  String targetId;

  String status;
  String pesanPengajuan;

  Timestamp? createdAt;

  // ambil dari profile
  String namaLengkap;
  String jenisKelamin;
  int usia;
  String domisili;
  String? fotoProfil;
  String pendidikan;
  String pekerjaan;

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
    return {
      'pengajuId': pengajuId,
      'targetId': targetId,
      'status': status,
      'pesanPengajuan': pesanPengajuan,
      'createdAt': FieldValue.serverTimestamp(),
      'namaLengkap': namaLengkap,
      'jenisKelamin': jenisKelamin,
      'usia': usia,
      'domisili': domisili,
      'fotoProfil': fotoProfil,
      'pendidikan': pendidikan,
      'pekerjaan': pekerjaan,
    };
  }

  factory InboxModel.fromMap(String id, Map<String, dynamic> map) {
    return InboxModel(
      id: id,
      pengajuId: map['pengajuId'] ?? '',
      targetId: map['targetId'] ?? '',
      status: map['status'] ?? 'pending',
      pesanPengajuan: map['pesanPengajuan'] ?? '',
      createdAt: map['createdAt'],
      namaLengkap: map['namaLengkap'] ?? '-',
      jenisKelamin: map['jenisKelamin'] ?? '-',
      usia: map['usia'] ?? 0,
      domisili: map['domisili'] ?? '-',
      fotoProfil: map['fotoProfil'],
      pendidikan: map['pendidikan'] ?? '-',
      pekerjaan: map['pekerjaan'] ?? '-',
    );
  }
}
