import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> getDaftarChatUser(uid) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final query = await _firestore
        .collection('chat_rooms')
        .where('members', arrayContains: user.uid)
        .orderBy('updatedAt', descending: true)
        .get();

    return query.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();
  }

  Future<String?> kirimPesan({
    required String ruangChatId,
    required String pesan,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return 'User belum login';

    try {
      await _firestore
          .collection('chat_rooms')
          .doc(ruangChatId)
          .collection('messages')
          .add({
            'senderId': user.uid,
            'pesan': pesan,
            'createdAt': FieldValue.serverTimestamp(),
          });

      await _firestore.collection('chat_rooms').doc(ruangChatId).update({
        'lastMessage': pesan,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return null;
    } catch (e) {
      return 'Gagal kirim pesan';
    }
  }

  Stream<QuerySnapshot> streamPesanChat(String ruangChatId) {
    return _firestore
        .collection('chat_rooms')
        .doc(ruangChatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots();
  }
}
