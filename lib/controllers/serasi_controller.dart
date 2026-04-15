import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zawj_app/models/serasi_model.dart';

class SerasiController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Ambil profil serasi
  Future<List<SerasiModel>> getSerasiProfiles({
    required String currentGender,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final query = await _firestore
        .collection('profiles')
        .where('jenis_kelamin', isNotEqualTo: currentGender)
        .get();

    return query.docs
        .where((doc) => doc.id != user.uid)
        .map((e) => SerasiModel.fromMap(e.data()))
        .toList();
  }

  /// Validasi sebelum taaruf
  Future<String?> validateAjukanTaaruf({required String targetId}) async {
    final user = _auth.currentUser;
    if (user == null) return 'User belum login';

    final query = await _firestore
        .collection('taaruf_requests')
        .where('pengajuId', isEqualTo: user.uid)
        .where('targetId', isEqualTo: targetId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (query.docs.isNotEmpty) {
      return 'Kamu sudah mengajukan taaruf ke user ini';
    }

    return null;
  }

  /// Kirim taaruf
  Future<String?> submitTaarufRequest({
    required String targetId,
    String? pesanPengajuan,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return 'User belum login';

    try {
      await _firestore.collection('taaruf_requests').add({
        'pengajuId': user.uid,
        'targetId': targetId,
        'pesan': pesanPengajuan ?? '',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null;
    } catch (e) {
      return 'Gagal mengirim taaruf';
    }
  }
}
