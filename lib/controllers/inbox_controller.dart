import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zawj_app/models/inbox_model.dart';
import 'package:zawj_app/services/firebase_service.dart';

class InboxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<InboxModel>> getInboxTaaruf() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final query = await _firestore
        .collection('taaruf_requests')
        .where('targetId', isEqualTo: user.uid)
        .get();

    return query.docs
        .map((doc) => InboxModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<String?> terimaTaaruf(String requestId) async {
    try {
      final requestRef = _firestore.collection('taaruf_requests').doc(requestId);

      final existingRoom = await _firestore
          .collection('chat_rooms')
          .where('requestId', isEqualTo: requestId)
          .limit(1)
          .get();

      if (existingRoom.docs.isNotEmpty) {
        await requestRef.update({'status': 'accepted'});
        return null;
      }

      await requestRef.update({
        'status': 'accepted',
      });

      final requestDoc = await requestRef.get();
      final data = requestDoc.data();
      if (data == null) return 'Data taaruf tidak ditemukan';

      final pengajuId = data['pengajuId']?.toString() ?? '';
      final targetId = data['targetId']?.toString() ?? '';

      if (pengajuId.isEmpty || targetId.isEmpty) {
        return 'Data pengguna tidak lengkap';
      }

      final pengajuProfileDoc = await _firestore
          .collection('profiles')
          .doc(pengajuId)
          .get();
      final targetProfileDoc = await _firestore
          .collection('profiles')
          .doc(targetId)
          .get();

      final pengajuProfile = pengajuProfileDoc.data() ?? {};
      final targetProfile = targetProfileDoc.data() ?? {};

      final pengajuGender = (pengajuProfile['jenisKelamin'] ?? '').toString();
      final targetGender = (targetProfile['jenisKelamin'] ?? '').toString();

      final pengajuIsIkhwan = pengajuGender.toLowerCase().contains('ikhwan');
      final targetIsIkhwan = targetGender.toLowerCase().contains('ikhwan');

      final ikhwanId = pengajuIsIkhwan ? pengajuId : targetId;
      final akhwatId = targetIsIkhwan ? pengajuId : targetId;
      final namaIkhwan = pengajuIsIkhwan
          ? (pengajuProfile['namaLengkap'] ?? data['namaLengkap'] ?? '-')
          : (targetProfile['namaLengkap'] ?? '-');
      final namaAkhwat = targetIsIkhwan
          ? (pengajuProfile['namaLengkap'] ?? data['namaLengkap'] ?? '-')
          : (targetProfile['namaLengkap'] ?? '-');

      final ustadzUser = await FirebaseService.getRandomUstadz();
      if (ustadzUser == null) {
        return 'Ustadz belum tersedia';
      }

      final ustadzId = ustadzUser.id;
      final namaUstadz = ustadzUser.nama.isNotEmpty ? ustadzUser.nama : 'Ustadz';

      if (ustadzId.isEmpty) {
        return 'Data ustadz tidak valid';
      }

      await _firestore.collection('chat_rooms').add({
        'members': [pengajuId, targetId, ustadzId],
        'requestId': requestId, // WAJIB supaya bisa dicari
        'pengajuId': pengajuId,
        'targetId': targetId,
        'ikhwanId': ikhwanId,
        'akhwatId': akhwatId,
        'ustadzId': ustadzId,
        'nama_ikhwan': namaIkhwan,
        'nama_akhwat': namaAkhwat,
        'nama_ustadz': namaUstadz,
        'lastMessage': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return null;
    } catch (e) {
      return 'Gagal menerima taaruf';
    }
  }

  Future<void> tolakTaaruf(String requestId) async {
    await _firestore.collection('taaruf_requests').doc(requestId).update({
      'status': 'rejected',
    });
  }

  Future<bool> hapusInbox(String requestId) async {
    try {
      await _firestore.collection('taaruf_requests').doc(requestId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getRuangChatByRequestId(
    String requestId,
  ) async {
    final query = await _firestore
        .collection('chat_rooms')
        .where('requestId', isEqualTo: requestId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    return {'id': query.docs.first.id, ...query.docs.first.data()};
  }
}
