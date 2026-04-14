class UserModelFirebase {
  final String id;
  final String nama;
  final String email;
  final String role;

  UserModelFirebase({
    required this.id,
    required this.nama,
    required this.email,
    this.role = 'user',
  });

  Map<String, dynamic> toMap() {
    return {'nama': nama, 'email': email, 'role': role};
  }

  factory UserModelFirebase.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return UserModelFirebase(
      id: documentId,
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
    );
  }
}
