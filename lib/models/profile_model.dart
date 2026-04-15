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
    this.waliTahu = false,
    this.bersediaPindah = false,
    this.tentangSaya,
    this.statusNikah,
    this.punyaAnak = false,
    this.jumlahAnak = 0,
    this.mauPoligami,
    this.sholat,
    this.kajianRutin,
    this.hafalanQuran,
    this.bercadar = false,
    this.panjangHijab,
    this.fotoKtp,
    this.akteCerai,
    this.buktiSedekah,
    this.setujuTidakKomunikasiDiluarSistem = false,
    this.setujuSatuTaarufSatuWaktu = false,
    this.setujuKebijakanPrivasi = false,
    this.isProfileComplete = false,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
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
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
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
      waliTahu: map['waliTahu'] ?? false,
      bersediaPindah: map['bersediaPindah'] ?? false,
      tentangSaya: map['tentangSaya'],
      statusNikah: map['statusNikah'],
      punyaAnak: map['punyaAnak'] ?? false,
      jumlahAnak: map['jumlahAnak'] ?? 0,
      mauPoligami: map['mauPoligami'],
      sholat: map['sholat'],
      kajianRutin: map['kajianRutin'],
      hafalanQuran: map['hafalanQuran'],
      bercadar: map['bercadar'] ?? false,
      panjangHijab: map['panjangHijab'],
      fotoKtp: map['fotoKtp'],
      akteCerai: map['akteCerai'],
      buktiSedekah: map['buktiSedekah'],
      setujuTidakKomunikasiDiluarSistem:
          map['setujuTidakKomunikasiDiluarSistem'] ?? false,
      setujuSatuTaarufSatuWaktu: map['setujuSatuTaarufSatuWaktu'] ?? false,
      setujuKebijakanPrivasi: map['setujuKebijakanPrivasi'] ?? false,
      isProfileComplete: map['isProfileComplete'] ?? false,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source));
}
