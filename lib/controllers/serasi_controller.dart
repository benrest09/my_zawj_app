import 'package:zawj_app/database/sqflite.dart';
import 'package:zawj_app/models/serasi_model.dart';

class SerasiController {
  Future<List<SerasiModel>> getSerasiProfiles({
    required int currentUserId,
    required String currentGender,
  }) async {
    final result = await DBHelper.getSerasiProfiles(
      currentUserId: currentUserId,
      currentGender: currentGender,
    );

    return result.map((e) => SerasiModel.fromMap(e)).toList();
  }

  Future<String?> validateAjukanTaaruf({
    required int pengajuId,
    required int targetId,
  }) async {
    return await DBHelper.validateSebelumAjukanTaaruf(
      pengajuId: pengajuId,
      targetId: targetId,
    );
  }

  Future<int> submitTaarufRequest({
    required int pengajuId,
    required int targetId,
    String? pesanPengajuan,
  }) async {
    return await DBHelper.createTaarufRequest(
      pengajuId: pengajuId,
      targetId: targetId,
      pesanPengajuan: pesanPengajuan,
    );
  }
}
