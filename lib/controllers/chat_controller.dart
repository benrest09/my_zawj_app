import 'package:zawj_app/database/sqflite.dart';

class ChatController {
  Future<List<Map<String, dynamic>>> getDaftarChatUser(int userId) async {
    return await DBHelper.getDaftarChatUser(userId);
  }

  Future<List<Map<String, dynamic>>> getPesanChat(int ruangChatId) async {
    return await DBHelper.getPesanChat(ruangChatId);
  }

  Future<int> kirimPesan({
    required int ruangChatId,
    required int senderId,
    required String pesan,
  }) async {
    if (pesan.trim().isEmpty) {
      return 0;
    }

    return await DBHelper.sendPesanChat(
      ruangChatId: ruangChatId,
      senderId: senderId,
      pesan: pesan.trim(),
    );
  }
}
