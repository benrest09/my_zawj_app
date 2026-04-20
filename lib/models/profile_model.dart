import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  String uid;

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
  String? statusNikah;
  String? mauPoligami;
  String? sholat;
  String? kajianRutin;
  String? hafalanQuran;
  String? panjangHijab;

  String? tentangSaya;
  String? jumlahAnak;

  bool waliTahu;
  bool bersediaPindah;
  bool punyaAnak;
  bool bercadar;
  bool setujuTidakKomunikasi;
  bool setujuSatuTaaruf;
  bool setujuKebijakan;

  String? fotoKtp;
  String? akteCerai;
  String? buktiSedekah;

  bool isProfileComplete;

  Timestamp? createdAt;
  Timestamp? updatedAt;

  ProfileModel({
    required this.uid,
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
    this.statusNikah,
    this.mauPoligami,
    this.sholat,
    this.kajianRutin,
    this.hafalanQuran,
    this.panjangHijab,
    this.tentangSaya,
    this.jumlahAnak,
    this.waliTahu = false,
    this.bersediaPindah = false,
    this.punyaAnak = false,
    this.bercadar = false,
    this.setujuTidakKomunikasi = false,
    this.setujuSatuTaaruf = false,
    this.setujuKebijakan = false,
    this.fotoKtp,
    this.akteCerai,
    this.buktiSedekah,
    this.isProfileComplete = false,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    final isIkhwan = jenisKelamin == 'Ikhwan';

    return {
      'uid': uid,
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
      'statusNikah': statusNikah,

     
      'mauPoligami': isIkhwan ? null : mauPoligami,
      'panjangHijab': isIkhwan ? null : panjangHijab,

      'sholat': sholat,
      'kajianRutin': kajianRutin,
      'hafalanQuran': hafalanQuran,

      'tentangSaya': tentangSaya,
      'jumlahAnak': jumlahAnak,
      'waliTahu': waliTahu,
      'bersediaPindah': bersediaPindah,
      'punyaAnak': punyaAnak,
      'bercadar': bercadar,
      'setujuTidakKomunikasi': setujuTidakKomunikasi,
      'setujuSatuTaaruf': setujuSatuTaaruf,
      'setujuKebijakan': setujuKebijakan,
      'fotoKtp': fotoKtp,
      'akteCerai': akteCerai,
      'buktiSedekah': buktiSedekah,
      'isProfileComplete': isProfileComplete,
      'createdAt': createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      uid: map['uid'] ?? '',
      fotoProfil: map['fotoProfil'],
      namaLengkap: map['namaLengkap'],
      jenisKelamin: map['jenisKelamin'],
      tanggalLahir: map['tanggalLahir'],
      usia: map['usia'],
      tempatLahir: map['tempatLahir'],
      domisili: map['domisili'],
      suku: map['suku'],
      kewarganegaraan: map['kewarganegaraan'],
      pendidikan: map['pendidikan'],
      pekerjaan: map['pekerjaan'],
      bidangPekerjaan: map['bidangPekerjaan'],
      penghasilan: map['penghasilan'],
      targetNikah: map['targetNikah'],
      statusNikah: map['statusNikah'],
      mauPoligami: map['mauPoligami'],
      sholat: map['sholat'],
      kajianRutin: map['kajianRutin'],
      hafalanQuran: map['hafalanQuran'],
      panjangHijab: map['panjangHijab'],
      tentangSaya: map['tentangSaya'],
      jumlahAnak: map['jumlahAnak'],
      waliTahu: map['waliTahu'] ?? false,
      bersediaPindah: map['bersediaPindah'] ?? false,
      punyaAnak: map['punyaAnak'] ?? false,
      bercadar: map['bercadar'] ?? false,
      setujuTidakKomunikasi: map['setujuTidakKomunikasi'] ?? false,
      setujuSatuTaaruf: map['setujuSatuTaaruf'] ?? false,
      setujuKebijakan: map['setujuKebijakan'] ?? false,
      fotoKtp: map['fotoKtp'],
      akteCerai: map['akteCerai'],
      buktiSedekah: map['buktiSedekah'],
      isProfileComplete: map['isProfileComplete'] ?? false,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source));
}
