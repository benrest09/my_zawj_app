import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/serasi_model.dart';

class SerasiController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<SerasiModel>> streamSerasiProfiles({
    required String currentGender,
  }) {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('profiles')
        .where('isProfileComplete', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .where((doc) {
                final data = doc.data();
                final gender = normalisasiJenisKelamin(
                  data['jenisKelamin']?.toString() ?? '',
                );

                return doc.id != user.uid && gender.isNotEmpty && gender != currentGender;
              })
              .map((doc) => SerasiModel.fromMap({
                    ...doc.data(),
                    'uid': doc.id,
                  }))
              .toList(),
        );
  }

  Future<String?> validateAjukanTaaruf({
    required String pengajuId,
    required String targetId,
  }) async {
    final query = await _firestore
        .collection('taaruf_requests')
        .where('pengajuId', isEqualTo: pengajuId)
        .where('targetId', isEqualTo: targetId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (query.docs.isNotEmpty) {
      return 'Kamu sudah mengajukan taaruf ke user ini';
    }

    return null;
  }

  Future<String?> submitTaarufRequest({
    required String targetId,
    String? pesanPengajuan,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return 'User belum login';

    try {
      final pengajuProfileDoc = await _firestore
          .collection('profiles')
          .doc(user.uid)
          .get();

      final pengajuProfile = pengajuProfileDoc.data() ?? {};

      await _firestore.collection('taaruf_requests').add({
        'pengajuId': user.uid,
        'targetId': targetId,
        'namaLengkap':
            pengajuProfile['namaLengkap'] ?? user.displayName ?? 'Tanpa Nama',
        'jenisKelamin': pengajuProfile['jenisKelamin'] ?? '-',
        'usia': pengajuProfile['usia'] ?? 0,
        'domisili': pengajuProfile['domisili'] ?? '-',
        'fotoProfil': pengajuProfile['fotoProfil'],
        'pendidikan': pengajuProfile['pendidikan'] ?? '-',
        'pekerjaan': pengajuProfile['pekerjaan'] ?? '-',
        'pesanPengajuan': pesanPengajuan ?? '',
        'pesan': pesanPengajuan ?? '',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null;
    } catch (e) {
      return 'Gagal kirim';
    }
  }

  Future<Map<String, dynamic>?> getProfileByUserId(String uid) async {
    final doc = await _firestore.collection('profiles').doc(uid).get();
    return doc.data();
  }

  String normalisasiJenisKelamin(String value) {
    final v = value.toLowerCase();

    if (v.contains('akhwat')) return 'Akhwat';
    if (v.contains('ikhwan')) return 'Ikhwan';

    return '';
  }
}
