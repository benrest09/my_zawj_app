import 'dart:convert';

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
      'pengaju_id': pengajuId,
      'target_id': targetId,
      'status': status,
      'pesan_pengajuan': pesanPengajuan,
      'created_at': createdAt,
      'nama_lengkap': namaLengkap,
      'jenis_kelamin': jenisKelamin,
      'usia': usia,
      'domisili': domisili,
      'foto_profil': fotoProfil,
      'pendidikan': pendidikan,
      'pekerjaan': pekerjaan,
    };
  }

  factory InboxModel.fromMap(Map<String, dynamic> map) {
    return InboxModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? '0') ?? 0,
      pengajuId: map['pengaju_id'] is int
          ? map['pengaju_id'] as int
          : int.tryParse(map['pengaju_id']?.toString() ?? '0') ?? 0,
      targetId: map['target_id'] is int
          ? map['target_id'] as int
          : int.tryParse(map['target_id']?.toString() ?? '0') ?? 0,
      status: map['status']?.toString() ?? 'pending',
      pesanPengajuan: map['pesan_pengajuan']?.toString() ?? '',
      createdAt: map['created_at']?.toString(),
      namaLengkap: map['nama_lengkap']?.toString() ?? '-',
      jenisKelamin: map['jenis_kelamin']?.toString() ?? '-',
      usia: map['usia'] is int
          ? map['usia'] as int
          : int.tryParse(map['usia']?.toString() ?? '0') ?? 0,
      domisili: map['domisili']?.toString() ?? '-',
      fotoProfil: map['foto_profil']?.toString(),
      pendidikan: map['pendidikan']?.toString() ?? '-',
      pekerjaan: map['pekerjaan']?.toString() ?? '-',
    );
  }

  String toJson() => json.encode(toMap());

  factory InboxModel.fromJson(String source) =>
      InboxModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
