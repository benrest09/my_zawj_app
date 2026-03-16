import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SesiTaarufModel {
  int? id;
  int taarufRequestId;

  int ikhwanId;
  int akhwatId;

  int? ustadzId;

  String statusSesi;

  String? createdAt;
  String? updatedAt;
  String? selesaiAt;

  SesiTaarufModel({
    this.id,
    required this.taarufRequestId,
    required this.ikhwanId,
    required this.akhwatId,
    this.ustadzId,
    required this.statusSesi,
    this.createdAt,
    this.updatedAt,
    this.selesaiAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'taarufRequestId': taarufRequestId,
      'ikhwanId': ikhwanId,
      'akhwatId': akhwatId,
      'ustadzId': ustadzId,
      'statusSesi': statusSesi,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'selesaiAt': selesaiAt,
    };
  }

  factory SesiTaarufModel.fromMap(Map<String, dynamic> map) {
    return SesiTaarufModel(
      id: map['id'] != null ? map['id'] as int : null,
      taarufRequestId: map['taarufRequestId'] as int,
      ikhwanId: map['ikhwanId'] as int,
      akhwatId: map['akhwatId'] as int,
      ustadzId: map['ustadzId'] != null ? map['ustadzId'] as int : null,
      statusSesi: map['statusSesi'] as String,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      selesaiAt: map['selesaiAt'] != null ? map['selesaiAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SesiTaarufModel.fromJson(String source) =>
      SesiTaarufModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
