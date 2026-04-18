import 'package:cloud_firestore/cloud_firestore.dart';

class ChatgroupModel {
  final String id;
  final String sesiTaarufId;
  final String namaIkhwan;
  final String namaAkhwat;
  final String ikhwanId;
  final String akhwatId;
  final String? ustadzId;
  final List<String> members; // [ikhwanId, akhwatId, ustadzId]
  final String? lastMessage;
  final Timestamp? updatedAt;
  final Timestamp? createdAt;

  ChatgroupModel({
    required this.id,
    required this.sesiTaarufId,
    required this.namaIkhwan,
    required this.namaAkhwat,
    required this.ikhwanId,
    required this.akhwatId,
    this.ustadzId,
    required this.members,
    this.lastMessage,
    this.updatedAt,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'sesiTaarufId': sesiTaarufId,
      'nama_ikhwan': namaIkhwan,
      'nama_akhwat': namaAkhwat,
      'ikhwanId': ikhwanId,
      'akhwatId': akhwatId,
      'ustadzId': ustadzId,
      'members': members,
      'lastMessage': lastMessage ?? '',
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory ChatgroupModel.fromMap(Map<String, dynamic> map, String docId) {
    return ChatgroupModel(
      id: docId,
      sesiTaarufId: map['sesiTaarufId'] ?? '',
      namaIkhwan: map['nama_ikhwan'] ?? '-',
      namaAkhwat: map['nama_akhwat'] ?? '-',
      ikhwanId: map['ikhwanId'] ?? '',
      akhwatId: map['akhwatId'] ?? '',
      ustadzId: map['ustadzId'],
      members: List<String>.from(map['members'] ?? []),
      lastMessage: map['lastMessage'],
      updatedAt: map['updatedAt'],
      createdAt: map['createdAt'],
    );
  }
}
