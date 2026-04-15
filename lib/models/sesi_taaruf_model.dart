import 'package:cloud_firestore/cloud_firestore.dart';

class SesiTaarufModel {
  String id;
  String taarufRequestId;

  String ikhwanId;
  String akhwatId;
  String? ustadzId;

  String statusSesi;

  Timestamp? createdAt;
  Timestamp? updatedAt;
  Timestamp? selesaiAt;

  SesiTaarufModel({
    required this.id,
    required this.taarufRequestId,
    required this.ikhwanId,
    required this.akhwatId,
    this.ustadzId,
    required this.statusSesi,
    this.createdAt,
    this.updatedAt,
    this.selesaiAt,
  });
}
