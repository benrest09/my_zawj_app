import 'package:cloud_firestore/cloud_firestore.dart';

class ChatgroupModel {
  String id;
  String sesiTaarufId;

  String? namaRuang;
  Timestamp? createdAt;

  ChatgroupModel({
    required this.id,
    required this.sesiTaarufId,
    this.namaRuang,
    this.createdAt,
  });
}
