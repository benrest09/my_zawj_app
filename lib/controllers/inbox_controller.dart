import 'package:zawj_app/database/sqflite.dart';
import 'package:zawj_app/models/inbox_model.dart';

class InboxController {
  Future<List<InboxModel>> getInboxTaaruf(int userId) async {
    final result = await DBHelper.getInboxTaarufDetail(userId);
    return result.map((e) => InboxModel.fromMap(e)).toList();
  }

  Future<String?> terimaTaaruf(int requestId) async {
    return await DBHelper.terimaTaarufRequest(requestId: requestId);
  }

  Future<void> tolakTaaruf(int requestId) async {
    await DBHelper.tolakTaarufRequest(requestId: requestId);
  }

  Future<bool> hapusInbox(int requestId) async {
    final result = await DBHelper.hapusInboxRequest(requestId: requestId);
    return result > 0;
  }
}
