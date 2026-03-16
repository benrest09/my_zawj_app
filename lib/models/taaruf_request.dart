import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TaarufRequestModel {
  int? id;
  int pengajuId;
  int targetId;
  String status;
  String? pesanPengajuan;
  String? createdAt;
  String? updatedAt;

  TaarufRequestModel({
    this.id,
    required this.pengajuId,
    required this.targetId,
    required this.status,
    this.pesanPengajuan,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pengajuId': pengajuId,
      'targetId': targetId,
      'status': status,
      'pesanPengajuan': pesanPengajuan,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory TaarufRequestModel.fromMap(Map<String, dynamic> map) {
    return TaarufRequestModel(
      id: map['id'] != null ? map['id'] as int : null,
      pengajuId: map['pengajuId'] as int,
      targetId: map['targetId'] as int,
      status: map['status'] as String,
      pesanPengajuan: map['pesanPengajuan'] != null
          ? map['pesanPengajuan'] as String
          : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaarufRequestModel.fromJson(String source) =>
      TaarufRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
