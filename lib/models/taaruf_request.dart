import 'package:cloud_firestore/cloud_firestore.dart';

class TaarufRequestModel {
  String id;
  String pengajuId;
  String targetId;

  String status;
  String? pesanPengajuan;

  Timestamp? createdAt;
  Timestamp? updatedAt;

  TaarufRequestModel({
    required this.id,
    required this.pengajuId,
    required this.targetId,
    required this.status,
    this.pesanPengajuan,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'pengajuId': pengajuId,
      'targetId': targetId,
      'status': status,
      'pesanPengajuan': pesanPengajuan,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory TaarufRequestModel.fromMap(String id, Map<String, dynamic> map) {
    return TaarufRequestModel(
      id: id,
      pengajuId: map['pengajuId'] ?? '',
      targetId: map['targetId'] ?? '',
      status: map['status'] ?? 'pending',
      pesanPengajuan: map['pesanPengajuan'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
