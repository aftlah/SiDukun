import 'package:cloud_firestore/cloud_firestore.dart';

class Penduduk {
  String id;
  String nik;
  String nama;
  String gender;
  String pekerjaan;
  String statusNikah;
  String agama;
  DateTime tanggalLahir;
  String tempatLahir;
  DateTime createdAt;
  DateTime updatedAt;
  String noHp;
  String email;

  // Constructor itu buat menginisialisasi objek ketika objek tersebut dibuat.
  Penduduk({
    required this.id,
    required this.nik,
    required this.nama,
    required this.gender,
    required this.pekerjaan,
    required this.statusNikah,
    required this.tanggalLahir,
    required this.agama,
    required this.tempatLahir,
    required this.createdAt,
    required this.updatedAt,
    required this.noHp,
    required this.email,
  });

  factory Penduduk.fromMap(Map<String, dynamic> data, String documentId) {
    return Penduduk(
      id: documentId,
      nik: data['nik'],
      nama: data['nama'],
      gender: data['gender'],
      pekerjaan: data['pekerjaan'],
      statusNikah: data['statusNikah'],
      tanggalLahir: (data['tanggalLahir'] as Timestamp).toDate(),
      agama: data['agama'],
      tempatLahir: data['tempatLahir'],
      noHp: data['noHp'],
      email: data['email'],
      createdAt: (data['createdAt'] as Timestamp).toDate(), 
      updatedAt: (data['updatedAt'] as Timestamp).toDate(), 
    );
  }

  get jenisKelamin => null;

  get statusPerkawinan => null;

  Map<String, dynamic> toMap() {
    return {
      'nik': nik,
      'nama': nama,
      'gender': gender,
      'pekerjaan': pekerjaan,
      'statusNikah': statusNikah,
      'tanggalLahir': tanggalLahir,
      'agama': agama,
      'tempatLahir': tempatLahir,
      'noHp': noHp,
      'email': email,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
