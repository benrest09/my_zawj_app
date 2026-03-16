class UserModel {
  final int? id;
  final String nama;
  final String email;
  final String password;
  final String? role;
  final String? statusTaaruf;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    required this.nama,
    required this.email,
    required this.password,
    this.role,
    this.statusTaaruf,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'password': password,
      'role': role ?? 'user',
      'status_taaruf': statusTaaruf ?? 'tersedia',
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
      'updated_at': updatedAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      nama: map['nama'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      statusTaaruf: map['status_taaruf'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
