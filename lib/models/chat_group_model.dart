import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatgroupModel {
  int? id;
  int sesiTaarufId;
  String? namaRuang;
  String? createdAt;

  ChatgroupModel({
    this.id,
    required this.sesiTaarufId,
    this.namaRuang,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sesiTaarufId': sesiTaarufId,
      'namaRuang': namaRuang,
      'createdAt': createdAt,
    };
  }

  factory ChatgroupModel.fromMap(Map<String, dynamic> map) {
    return ChatgroupModel(
      id: map['id'] != null ? map['id'] as int : null,
      sesiTaarufId: map['sesiTaarufId'] as int,
      namaRuang: map['namaRuang'] != null ? map['namaRuang'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatgroupModel.fromJson(String source) =>
      ChatgroupModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
