import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zawj_app/models/inbox_model.dart';

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
      await _firestore.collection('taaruf_requests').doc(requestId).update({
        'status': 'accepted',
      });

      final requestDoc = await _firestore
          .collection('taaruf_requests')
          .doc(requestId)
          .get();
      final data = requestDoc.data();

      await _firestore.collection('chat_rooms').add({
        'members': [data?['pengajuId'], data?['targetId']],
        'requestId': requestId, // WAJIB supaya bisa dicari
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null;
    } catch (e) {
      return 'Gagal menerima taaruf';
    }
  }

  Future<void> tolakTaaruf(String requestId) async {
    await _firestore.collection('taaruf_request').doc(requestId).update({
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

    return query.docs.first.data();
  }
}
