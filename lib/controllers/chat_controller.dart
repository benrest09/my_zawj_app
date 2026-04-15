import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///Ambil daftar chat user
  Future<List<Map<String, dynamic>>> getDaftarChatUser() async {
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

  ///Ambil pesan dalam ruang chat
  Future<List<Map<String, dynamic>>> getPesanChat(String ruangChatId) async {
    final query = await _firestore
        .collection('chat_rooms')
        .doc(ruangChatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .get();

    return query.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();
  }

  ///Kirim pesan
  Future<String?> kirimPesan({
    required String ruangChatId,
    required String pesan,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return 'User belum login';

    if (pesan.trim().isEmpty) {
      return 'Pesan tidak boleh kosong';
    }

    try {
      final messageData = {
        'senderId': user.uid,
        'pesan': pesan.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      /// simpan ke subcollection messages
      await _firestore
          .collection('chat_rooms')
          .doc(ruangChatId)
          .collection('messages')
          .add(messageData);

      /// update last message di chat room (biar list chat ada preview)
      await _firestore.collection('chat_rooms').doc(ruangChatId).update({
        'lastMessage': pesan.trim(),
        'lastSenderId': user.uid,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return null; // sukses
    } catch (e) {
      return 'Gagal mengirim pesan';
    }
  }

  //realtime stream pesan
  Stream<QuerySnapshot> streamPesanChat(String ruangChatId) {
    return _firestore
        .collection('chat_rooms')
        .doc(ruangChatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots();
  }

  //realtime daftar chat
  Stream<QuerySnapshot> streamDaftarChatUser() {
    final user = _auth.currentUser;

    return _firestore
        .collection('chat_rooms')
        .where('members', arrayContains: user?.uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }
}
