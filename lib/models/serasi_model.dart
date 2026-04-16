class SerasiModel {
  String uid;

  String namaLengkap;
  String jenisKelamin;
  int usia;
  String domisili;
  String pendidikan;
  String pekerjaan;
  String tentangSaya;
  String? fotoProfil;

  SerasiModel({
    required this.uid,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.usia,
    required this.domisili,
    required this.pendidikan,
    required this.pekerjaan,
    required this.tentangSaya,
    this.fotoProfil,
  });

  factory SerasiModel.fromMap(Map<String, dynamic> map) {
    return SerasiModel(
      uid: map['uid'] ?? '',
      namaLengkap: map['namaLengkap'] ?? '-',
      jenisKelamin: map['jenis_kelamin'] ?? '-',
      usia: map['usia'] ?? 0,
      domisili: map['domisili'] ?? '-',
      pendidikan: map['pendidikan'] ?? '-',
      pekerjaan: map['pekerjaan'] ?? '-',
      tentangSaya: map['tentangSaya'] ?? '-',
      fotoProfil: map['fotoProfil'],
    );
  }
}
