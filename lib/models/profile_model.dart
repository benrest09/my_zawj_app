import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfileModel {
  int? id;
  int userId;

  String? fotoProfil;

  String? namaLengkap;
  String? jenisKelamin;

  String? tanggalLahir;
  int? usia;
  String? tempatLahir;

  String? domisili;
  String? suku;
  String? kewarganegaraan;

  String? pendidikan;
  String? pekerjaan;
  String? bidangPekerjaan;
  String? penghasilan;

  String? targetNikah;

  bool waliTahu;
  bool bersediaPindah;

  String? tentangSaya;

  String? statusNikah;
  bool punyaAnak;
  int jumlahAnak;

  String? mauPoligami;

  String? sholat;
  String? kajianRutin;
  String? hafalanQuran;

  bool bercadar;
  String? panjangHijab;

  String? fotoKtp;
  String? akteCerai;
  String? buktiSedekah;

  bool setujuTidakKomunikasiDiluarSistem;
  bool setujuSatuTaarufSatuWaktu;
  bool setujuKebijakanPrivasi;

  bool isProfileComplete;

  String? createdAt;
  String? updatedAt;

  ProfileModel({
    this.id,
    required this.userId,
    this.fotoProfil,
    this.namaLengkap,
    this.jenisKelamin,
    this.tanggalLahir,
    this.usia,
    this.tempatLahir,
    this.domisili,
    this.suku,
    this.kewarganegaraan,
    this.pendidikan,
    this.pekerjaan,
    this.bidangPekerjaan,
    this.penghasilan,
    this.targetNikah,
    required this.waliTahu,
    required this.bersediaPindah,
    this.tentangSaya,
    this.statusNikah,
    required this.punyaAnak,
    required this.jumlahAnak,
    this.mauPoligami,
    this.sholat,
    this.kajianRutin,
    this.hafalanQuran,
    required this.bercadar,
    this.panjangHijab,
    this.fotoKtp,
    this.akteCerai,
    this.buktiSedekah,
    required this.setujuTidakKomunikasiDiluarSistem,
    required this.setujuSatuTaarufSatuWaktu,
    required this.setujuKebijakanPrivasi,
    required this.isProfileComplete,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'fotoProfil': fotoProfil,
      'namaLengkap': namaLengkap,
      'jenisKelamin': jenisKelamin,
      'tanggalLahir': tanggalLahir,
      'usia': usia,
      'tempatLahir': tempatLahir,
      'domisili': domisili,
      'suku': suku,
      'kewarganegaraan': kewarganegaraan,
      'pendidikan': pendidikan,
      'pekerjaan': pekerjaan,
      'bidangPekerjaan': bidangPekerjaan,
      'penghasilan': penghasilan,
      'targetNikah': targetNikah,
      'waliTahu': waliTahu,
      'bersediaPindah': bersediaPindah,
      'tentangSaya': tentangSaya,
      'statusNikah': statusNikah,
      'punyaAnak': punyaAnak,
      'jumlahAnak': jumlahAnak,
      'mauPoligami': mauPoligami,
      'sholat': sholat,
      'kajianRutin': kajianRutin,
      'hafalanQuran': hafalanQuran,
      'bercadar': bercadar,
      'panjangHijab': panjangHijab,
      'fotoKtp': fotoKtp,
      'akteCerai': akteCerai,
      'buktiSedekah': buktiSedekah,
      'setujuTidakKomunikasiDiluarSistem': setujuTidakKomunikasiDiluarSistem,
      'setujuSatuTaarufSatuWaktu': setujuSatuTaarufSatuWaktu,
      'setujuKebijakanPrivasi': setujuKebijakanPrivasi,
      'isProfileComplete': isProfileComplete,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] != null ? map['id'] as int : null,
      userId: map['userId'] as int,
      fotoProfil: map['fotoProfil'] != null
          ? map['fotoProfil'] as String
          : null,
      namaLengkap: map['namaLengkap'] != null
          ? map['namaLengkap'] as String
          : null,
      jenisKelamin: map['jenisKelamin'] != null
          ? map['jenisKelamin'] as String
          : null,
      tanggalLahir: map['tanggalLahir'] != null
          ? map['tanggalLahir'] as String
          : null,
      usia: map['usia'] != null ? map['usia'] as int : null,
      tempatLahir: map['tempatLahir'] != null
          ? map['tempatLahir'] as String
          : null,
      domisili: map['domisili'] != null ? map['domisili'] as String : null,
      suku: map['suku'] != null ? map['suku'] as String : null,
      kewarganegaraan: map['kewarganegaraan'] != null
          ? map['kewarganegaraan'] as String
          : null,
      pendidikan: map['pendidikan'] != null
          ? map['pendidikan'] as String
          : null,
      pekerjaan: map['pekerjaan'] != null ? map['pekerjaan'] as String : null,
      bidangPekerjaan: map['bidangPekerjaan'] != null
          ? map['bidangPekerjaan'] as String
          : null,
      penghasilan: map['penghasilan'] != null
          ? map['penghasilan'] as String
          : null,
      targetNikah: map['targetNikah'] != null
          ? map['targetNikah'] as String
          : null,
      waliTahu: map['waliTahu'] as bool,
      bersediaPindah: map['bersediaPindah'] as bool,
      tentangSaya: map['tentangSaya'] != null
          ? map['tentangSaya'] as String
          : null,
      statusNikah: map['statusNikah'] != null
          ? map['statusNikah'] as String
          : null,
      punyaAnak: map['punyaAnak'] as bool,
      jumlahAnak: map['jumlahAnak'] as int,
      mauPoligami: map['mauPoligami'] != null
          ? map['mauPoligami'] as String
          : null,
      sholat: map['sholat'] != null ? map['sholat'] as String : null,
      kajianRutin: map['kajianRutin'] != null
          ? map['kajianRutin'] as String
          : null,
      hafalanQuran: map['hafalanQuran'] != null
          ? map['hafalanQuran'] as String
          : null,
      bercadar: map['bercadar'] as bool,
      panjangHijab: map['panjangHijab'] != null
          ? map['panjangHijab'] as String
          : null,
      fotoKtp: map['fotoKtp'] != null ? map['fotoKtp'] as String : null,
      akteCerai: map['akteCerai'] != null ? map['akteCerai'] as String : null,
      buktiSedekah: map['buktiSedekah'] != null
          ? map['buktiSedekah'] as String
          : null,
      setujuTidakKomunikasiDiluarSistem:
          map['setujuTidakKomunikasiDiluarSistem'] as bool,
      setujuSatuTaarufSatuWaktu: map['setujuSatuTaarufSatuWaktu'] as bool,
      setujuKebijakanPrivasi: map['setujuKebijakanPrivasi'] as bool,
      isProfileComplete: map['isProfileComplete'] as bool,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
