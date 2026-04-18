import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zawj_app/models/chat_group_model.dart';
import 'package:zawj_app/services/firebase_service.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> buatGrupChat({
    required String sesiTaarufId,
    required String ikhwanId,
    required String namaIkhwan,
    required String akhwatId,
    required String namaAkhwat,
    String? ustadzId,
  }) async {
    try {
      // Susun daftar members
      final List<String> members = [ikhwanId, akhwatId];
      if (ustadzId != null && ustadzId.isNotEmpty) {
        members.add(ustadzId);
      }

      final grup = ChatgroupModel(
        id: '',
        sesiTaarufId: sesiTaarufId,
        namaIkhwan: namaIkhwan,
        namaAkhwat: namaAkhwat,
        ikhwanId: ikhwanId,
        akhwatId: akhwatId,
        ustadzId: ustadzId,
        members: members,
        lastMessage: '',
      );

      final docRef = await _firestore
          .collection('chat_rooms')
          .add(grup.toMap());

      return docRef.id; // return ID grup yang baru dibuat
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getDaftarChatUser(String uid) async {
    try {
      final query = await _firestore
          .collection('chat_rooms')
          .where('members', arrayContains: uid)
          .get();

      final hasil = query.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      hasil.sort((a, b) {
        final aTime = a['updatedAt'];
        final bTime = b['updatedAt'];
        final aMs = aTime is Timestamp ? aTime.millisecondsSinceEpoch : 0;
        final bMs = bTime is Timestamp ? bTime.millisecondsSinceEpoch : 0;
        return bMs.compareTo(aMs);
      });

      return hasil;
    } catch (e) {
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> streamDaftarChatUser(String uid) {
    return _firestore
        .collection('chat_rooms')
        .where('members', arrayContains: uid)
        .snapshots()
        .asyncMap((snapshot) async {
          final hasil = await Future.wait(
            snapshot.docs.map((doc) async {
              final data = await _pastikanUstadzDiGrup(
                ruangChatId: doc.id,
                data: doc.data(),
              );
              final roomInfo = await _buildRoomInfo(
                currentUserId: uid,
                data: data,
              );

              final namaLawanBicara = _getNamaLawanBicara(
                currentUserId: uid,
                roomInfo: roomInfo,
              );

              return {
                'id': doc.id,
                ...data,
                'namaLawanBicara': namaLawanBicara,
                'isGroupTaaruf': _isGroupTaaruf(data),
                'fotoProfilLawanBicara': roomInfo['fotoProfilLawanBicara'],
                'jenisKelaminLawanBicara': roomInfo['jenisKelaminLawanBicara'],
              };
            }),
          );

          hasil.sort((a, b) {
            final aTime = a['updatedAt'];
            final bTime = b['updatedAt'];
            final aMs = aTime is Timestamp ? aTime.millisecondsSinceEpoch : 0;
            final bMs = bTime is Timestamp ? bTime.millisecondsSinceEpoch : 0;
            return bMs.compareTo(aMs);
          });

          return hasil;
        });
  }

  Stream<Map<String, dynamic>?> streamInfoRuangChat(String ruangChatId) {
    return _firestore.collection('chat_rooms').doc(ruangChatId).snapshots().asyncMap((
      doc,
    ) async {
      if (!doc.exists) return null;

      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) return {'title': 'Chat'};

      final data = await _pastikanUstadzDiGrup(
        ruangChatId: doc.id,
        data: doc.data()!,
      );
      final roomInfo = await _buildRoomInfo(
        currentUserId: currentUserId,
        data: data,
      );

      return {
        ...roomInfo,
        'title': _getNamaLawanBicara(
          currentUserId: currentUserId,
          roomInfo: roomInfo,
        ),
      };
    });
  }

  bool _isGroupTaaruf(Map<String, dynamic> data) {
    final ustadzId = data['ustadzId']?.toString() ?? '';
    final namaUstadz = data['nama_ustadz']?.toString() ?? '';
    return ustadzId.isNotEmpty || namaUstadz.isNotEmpty;
  }

  Future<Map<String, dynamic>> _pastikanUstadzDiGrup({
    required String ruangChatId,
    required Map<String, dynamic> data,
  }) async {
    final ustadzId = data['ustadzId']?.toString() ?? '';
    final namaUstadz = data['nama_ustadz']?.toString() ?? '';
    final members = List<String>.from(data['members'] ?? []);

    if (ustadzId.isNotEmpty && namaUstadz.isNotEmpty && members.contains(ustadzId)) {
      return data;
    }

    final ustadzUser = await FirebaseService.getRandomUstadz();
    if (ustadzUser == null) {
      return data;
    }

    final updatedMembers = [...members];
    if (!updatedMembers.contains(ustadzUser.id)) {
      updatedMembers.add(ustadzUser.id);
    }

    final updatedData = {
      ...data,
      'ustadzId': ustadzUser.id,
      'nama_ustadz': ustadzUser.nama,
      'members': updatedMembers,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('chat_rooms').doc(ruangChatId).set(
      {
        'ustadzId': ustadzUser.id,
        'nama_ustadz': ustadzUser.nama,
        'members': updatedMembers,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    return updatedData;
  }

  Future<Map<String, dynamic>> _buildRoomInfo({
    required String currentUserId,
    required Map<String, dynamic> data,
  }) async {
    final ikhwanId = data['ikhwanId']?.toString() ?? '';
    final akhwatId = data['akhwatId']?.toString() ?? '';
    final ustadzId = data['ustadzId']?.toString() ?? '';

    final ikhwanProfile = ikhwanId.isEmpty
        ? null
        : await _firestore.collection('profiles').doc(ikhwanId).get();
    final akhwatProfile = akhwatId.isEmpty
        ? null
        : await _firestore.collection('profiles').doc(akhwatId).get();
    final ustadzUser = ustadzId.isEmpty
        ? null
        : await FirebaseService.getUserById(ustadzId);

    final namaIkhwan =
        ikhwanProfile?.data()?['namaLengkap']?.toString() ??
        data['nama_ikhwan']?.toString() ??
        'Ikhwan';
    final namaAkhwat =
        akhwatProfile?.data()?['namaLengkap']?.toString() ??
        data['nama_akhwat']?.toString() ??
        'Akhwat';
    final namaUstadz =
        ustadzUser?.nama.isNotEmpty == true
        ? ustadzUser!.nama
        : (data['nama_ustadz']?.toString() ?? 'Ustadz');

    Map<String, dynamic>? lawanProfile;
    if (currentUserId == ikhwanId) {
      lawanProfile = akhwatProfile?.data();
    } else if (currentUserId == akhwatId) {
      lawanProfile = ikhwanProfile?.data();
    }

    return {
      'ikhwanId': ikhwanId,
      'akhwatId': akhwatId,
      'ustadzId': ustadzId,
      'namaIkhwan': namaIkhwan,
      'namaAkhwat': namaAkhwat,
      'namaUstadz': namaUstadz,
      'fotoProfilLawanBicara': lawanProfile?['fotoProfil'],
      'jenisKelaminLawanBicara': lawanProfile?['jenisKelamin'] ?? '',
      'isGroupTaaruf': _isGroupTaaruf(data),
    };
  }

  String _getNamaLawanBicara({
    required String currentUserId,
    required Map<String, dynamic> roomInfo,
  }) {
    final ikhwanId = roomInfo['ikhwanId']?.toString();
    final akhwatId = roomInfo['akhwatId']?.toString();
    final namaIkhwan = roomInfo['namaIkhwan']?.toString() ?? 'Ikhwan';
    final namaAkhwat = roomInfo['namaAkhwat']?.toString() ?? 'Akhwat';
    final namaUstadz = roomInfo['namaUstadz']?.toString() ?? 'Ustadz';

    if (roomInfo['isGroupTaaruf'] == true) {
      if (currentUserId == ikhwanId) {
        return 'Group Taaruf: $namaAkhwat + Ustadz $namaUstadz';
      }

      if (currentUserId == akhwatId) {
        return 'Group Taaruf: $namaIkhwan + Ustadz $namaUstadz';
      }

      return 'Group Taaruf: $namaIkhwan & $namaAkhwat';
    }

    if (currentUserId == ikhwanId) {
      return namaAkhwat;
    }

    if (currentUserId == akhwatId) {
      return namaIkhwan;
    }

    return namaIkhwan;
  }

  Future<String?> ustadzGabungGrup(String ruangChatId) async {
    final user = _auth.currentUser;
    if (user == null) return 'Belum login';

    try {
      final docRef = _firestore.collection('chat_rooms').doc(ruangChatId);
      final doc = await docRef.get();

      if (!doc.exists) return 'Grup tidak ditemukan';

      final data = doc.data()!;
      final List<String> members = List<String>.from(data['members'] ?? []);

      // Cek apakah ustadz sudah ada di grup
      if (members.contains(user.uid)) return null;

      members.add(user.uid);

      await docRef.update({
        'ustadzId': user.uid,
        'members': members,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return null; // null = sukses
    } catch (e) {
      return 'Gagal bergabung ke grup';
    }
  }

  Future<List<Map<String, dynamic>>> getGrupTanpaUstadz() async {
    try {
      final query = await _firestore
          .collection('chat_rooms')
          .where('ustadzId', isNull: true)
          .get();

      return query.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<String?> kirimPesan({
    required String ruangChatId,
    required String pesan,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return 'User belum login';

    try {
      // Ambil nama terbaru dari profil, fallback ke data register.
      final profileDoc = await _firestore
          .collection('profiles')
          .doc(user.uid)
          .get();
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final namaPengirim =
          profileDoc.data()?['namaLengkap'] ??
          userDoc.data()?['nama'] ??
          'Unknown';

      await _firestore
          .collection('chat_rooms')
          .doc(ruangChatId)
          .collection('messages')
          .add({
            'senderId': user.uid,
            'namaPengirim': namaPengirim,
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

  Stream<List<Map<String, dynamic>>> streamPesanChatDetail(String ruangChatId) {
    return _firestore
        .collection('chat_rooms')
        .doc(ruangChatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .asyncMap((snapshot) async {
          return Future.wait(
            snapshot.docs.map((doc) async {
              final data = doc.data();
              final senderId = data['senderId']?.toString() ?? '';

              String namaTerbaru =
                  data['namaPengirim']?.toString() ?? 'Unknown';

              if (senderId.isNotEmpty) {
                final profileDoc = await _firestore
                    .collection('profiles')
                    .doc(senderId)
                    .get();
                final userDoc = await _firestore
                    .collection('users')
                    .doc(senderId)
                    .get();

                namaTerbaru =
                    profileDoc.data()?['namaLengkap']?.toString() ??
                    userDoc.data()?['nama']?.toString() ??
                    namaTerbaru;
              }

              return {
                'id': doc.id,
                ...data,
                'namaPengirimTampil': namaTerbaru,
              };
            }),
          );
        });
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
