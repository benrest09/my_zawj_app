import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zawj_app/models/user_model.dart';

class DBHelper {
  static Database? _database;

  static const String tabelUsers = 'users';
  static const String tabelUserProfiles = 'user_profiles';
  static const String tabelTaarufRequests = 'taaruf_requests';
  static const String tabelSesiTaaruf = 'sesi_taaruf';
  static const String tabelRuangChat = 'ruang_chat';
  static const String tabelPesanChat = 'pesan_chat';

  static const String statusPending = 'pending';
  static const String statusAccepted = 'accepted';
  static const String statusRejected = 'rejected';

  static const String statusSesiAktif = 'aktif';
  static const String statusSesiSelesai = 'selesai';

  static const String genderIkhwan = 'Ikhwan';
  static const String genderAkhwat = 'Akhwat';

  static Future<Database> db() async {
    if (_database != null) return _database!;
    _database = await _initDB();
    await seedUstadzJikaBelumAda();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_zawj.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            role TEXT DEFAULT 'user',
            status_taaruf TEXT DEFAULT 'tersedia',
            created_at TEXT,
            updated_at TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE user_profiles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL UNIQUE,

            foto_profil TEXT,

            nama_lengkap TEXT,
            jenis_kelamin TEXT,

            tanggal_lahir TEXT,
            usia INTEGER,
            tempat_lahir TEXT,

            domisili TEXT,
            suku TEXT,
            kewarganegaraan TEXT,

            pendidikan TEXT,
            pekerjaan TEXT,
            bidang_pekerjaan TEXT,
            penghasilan TEXT,

            target_nikah TEXT,

            wali_tahu INTEGER DEFAULT 0,
            bersedia_pindah INTEGER DEFAULT 0,

            tentang_saya TEXT,

            status_nikah TEXT,
            punya_anak INTEGER DEFAULT 0,
            jumlah_anak INTEGER DEFAULT 0,

            mau_poligami TEXT,

            sholat TEXT,
            kajian_rutin TEXT,
            hafalan_quran TEXT,
            bercadar INTEGER DEFAULT 0,
            panjang_hijab TEXT,

            foto_ktp TEXT,
            akte_cerai TEXT,
            bukti_sedekah TEXT,

            setuju_tidak_komunikasi_diluar_sistem INTEGER DEFAULT 0,
            setuju_satu_taaruf_satu_waktu INTEGER DEFAULT 0,
            setuju_kebijakan_privasi INTEGER DEFAULT 0,

            is_profile_complete INTEGER DEFAULT 0,

            created_at TEXT,
            updated_at TEXT,

            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE taaruf_requests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pengaju_id INTEGER NOT NULL,
            target_id INTEGER NOT NULL,
            status TEXT DEFAULT 'pending',
            pesan_pengajuan TEXT,
            created_at TEXT,
            updated_at TEXT,

            FOREIGN KEY (pengaju_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
            FOREIGN KEY (target_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE sesi_taaruf (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            taaruf_request_id INTEGER NOT NULL,
            ikhwan_id INTEGER NOT NULL,
            akhwat_id INTEGER NOT NULL,
            ustadz_id INTEGER,
            status_sesi TEXT DEFAULT 'aktif',
            created_at TEXT,
            updated_at TEXT,
            selesai_at TEXT,

            FOREIGN KEY (taaruf_request_id) REFERENCES taaruf_requests(id) ON DELETE CASCADE ON UPDATE CASCADE,
            FOREIGN KEY (ikhwan_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
            FOREIGN KEY (akhwat_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
            FOREIGN KEY (ustadz_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE ruang_chat (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sesi_taaruf_id INTEGER NOT NULL UNIQUE,
            nama_ruang TEXT,
            created_at TEXT,

            FOREIGN KEY (sesi_taaruf_id) REFERENCES sesi_taaruf(id) ON DELETE CASCADE ON UPDATE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE pesan_chat (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ruang_chat_id INTEGER NOT NULL,
            sender_id INTEGER NOT NULL,
            pesan TEXT NOT NULL,
            created_at TEXT,

            FOREIGN KEY (ruang_chat_id) REFERENCES ruang_chat(id) ON DELETE CASCADE ON UPDATE CASCADE,
            FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
          )
        ''');

        await db.execute(
          'CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id)',
        );
        await db.execute(
          'CREATE INDEX idx_taaruf_requests_pengaju_id ON taaruf_requests(pengaju_id)',
        );
        await db.execute(
          'CREATE INDEX idx_taaruf_requests_target_id ON taaruf_requests(target_id)',
        );
        await db.execute(
          'CREATE INDEX idx_taaruf_requests_status ON taaruf_requests(status)',
        );
        await db.execute(
          'CREATE INDEX idx_sesi_taaruf_ikhwan_id ON sesi_taaruf(ikhwan_id)',
        );
        await db.execute(
          'CREATE INDEX idx_sesi_taaruf_akhwat_id ON sesi_taaruf(akhwat_id)',
        );
        await db.execute(
          'CREATE INDEX idx_sesi_taaruf_status_sesi ON sesi_taaruf(status_sesi)',
        );
        await db.execute(
          'CREATE INDEX idx_pesan_chat_ruang_chat_id ON pesan_chat(ruang_chat_id)',
        );
      },
    );
  }

  static String normalisasiJenisKelamin(String value) {
    final hasil = value.trim().toLowerCase();
    if (hasil == 'ikhwan') return genderIkhwan;
    if (hasil == 'akhwat') return genderAkhwat;
    return value.trim();
  }

  static String targetJenisKelamin(String jenisKelamin) {
    final normal = normalisasiJenisKelamin(jenisKelamin);
    return normal == genderIkhwan ? genderAkhwat : genderIkhwan;
  }

  static Future<void> seedUstadzJikaBelumAda() async {
    final database = _database ?? await _initDB();

    final result = await database.query(
      tabelUsers,
      where: 'email = ?',
      whereArgs: ['ustadz@gmail.com'],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return;
    }

    final now = DateTime.now().toIso8601String();

    await database.insert(tabelUsers, {
      'nama': 'Ustadz Ahmad',
      'email': 'ustadz@gmail.com',
      'password': '123456',
      'role': 'ustadz',
      'status_taaruf': 'tersedia',
      'created_at': now,
      'updated_at': now,
    });
  }

  static Future<Map<String, dynamic>?> getUstadzDefault() async {
    final database = await db();

    final result = await database.query(
      tabelUsers,
      where: 'role = ?',
      whereArgs: ['ustadz'],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // REGISTER USER
  static Future<int> registerUser(UserModel user) async {
    final database = await db();
    final now = DateTime.now().toIso8601String();

    final data = {...user.toMap(), 'created_at': now, 'updated_at': now};

    return await database.insert(tabelUsers, data);
  }

  // LOGIN USER
  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final database = await db();

    final results = await database.query(
      tabelUsers,
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim(), password],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }

    return null;
  }

  // CEK EMAIL
  static Future<bool> isEmailExists(String email) async {
    final database = await db();

    final result = await database.query(
      tabelUsers,
      where: 'email = ?',
      whereArgs: [email.trim()],
    );

    return result.isNotEmpty;
  }

  // CREATE PROFILE
  static Future<int> createProfile(Map<String, dynamic> profile) async {
    final database = await db();
    return await database.insert(tabelUserProfiles, profile);
  }

  // GET PROFILE BY USER ID
  static Future<Map<String, dynamic>?> getProfileByUserId(int userId) async {
    final database = await db();

    final result = await database.query(
      tabelUserProfiles,
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // UPDATE PROFILE
  static Future<int> updateProfile(
    int userId,
    Map<String, dynamic> data,
  ) async {
    final database = await db();

    return await database.update(
      tabelUserProfiles,
      data,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // HAS PROFILE
  static Future<bool> hasProfile(int userId) async {
    final database = await db();

    final result = await database.query(
      tabelUserProfiles,
      where: 'user_id = ? AND is_profile_complete = 1',
      whereArgs: [userId],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // CREATE TAARUF REQUEST
  static Future<int> createTaarufRequest({
    required int pengajuId,
    required int targetId,
    String? pesanPengajuan,
  }) async {
    final database = await db();
    final now = DateTime.now().toIso8601String();

    return await database.insert(tabelTaarufRequests, {
      'pengaju_id': pengajuId,
      'target_id': targetId,
      'status': statusPending,
      'pesan_pengajuan': pesanPengajuan,
      'created_at': now,
      'updated_at': now,
    });
  }

  // GET TAARUF REQUESTS
  static Future<List<Map<String, dynamic>>> getTaarufRequests(
    int userId,
  ) async {
    final database = await db();

    return await database.query(
      tabelTaarufRequests,
      where: 'target_id = ? OR pengaju_id = ?',
      whereArgs: [userId, userId],
      orderBy: 'id DESC',
    );
  }

  // GET INBOX TAARUF DETAIL
  static Future<List<Map<String, dynamic>>> getInboxTaarufDetail(
    int userId,
  ) async {
    final database = await db();

    return await database.rawQuery(
      '''
      SELECT
        taaruf_requests.id,
        taaruf_requests.pengaju_id,
        taaruf_requests.target_id,
        taaruf_requests.status,
        taaruf_requests.pesan_pengajuan,
        taaruf_requests.created_at,
        taaruf_requests.updated_at,

        user_profiles.nama_lengkap,
        user_profiles.jenis_kelamin,
        user_profiles.usia,
        user_profiles.domisili,
        user_profiles.foto_profil,
        user_profiles.pendidikan,
        user_profiles.pekerjaan
      FROM taaruf_requests
      LEFT JOIN user_profiles
        ON user_profiles.user_id = taaruf_requests.pengaju_id
      WHERE taaruf_requests.target_id = ?
      ORDER BY taaruf_requests.id DESC
      ''',
      [userId],
    );
  }

  // GET USER PROFILE SINGKAT
  static Future<Map<String, dynamic>?> getUserProfileSingkat(int userId) async {
    final database = await db();

    final result = await database.query(
      tabelUserProfiles,
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // TERIMA TAARUF REQUEST
  static Future<String?> terimaTaarufRequest({required int requestId}) async {
    final database = await db();

    final requestResult = await database.query(
      tabelTaarufRequests,
      where: 'id = ?',
      whereArgs: [requestId],
      limit: 1,
    );

    if (requestResult.isEmpty) {
      return 'Pengajuan taaruf tidak ditemukan';
    }

    final request = requestResult.first;
    final int pengajuId = request['pengaju_id'] as int;
    final int targetId = request['target_id'] as int;

    final pengajuAktif = await userSedangDalamSesiAktif(pengajuId);
    if (pengajuAktif) {
      return 'Pengaju sedang dalam sesi taaruf aktif';
    }

    final targetAktif = await userSedangDalamSesiAktif(targetId);
    if (targetAktif) {
      return 'Kamu sedang dalam sesi taaruf aktif';
    }

    final pengajuProfile = await getUserProfileSingkat(pengajuId);
    final targetProfile = await getUserProfileSingkat(targetId);

    if (pengajuProfile == null || targetProfile == null) {
      return 'Profil user tidak ditemukan';
    }

    final ustadz = await getUstadzDefault();
    if (ustadz == null) {
      return 'Akun ustadz belum tersedia';
    }

    final int ustadzId = ustadz['id'] as int;

    final String jenisKelaminPengaju = normalisasiJenisKelamin(
      pengajuProfile['jenis_kelamin']?.toString() ?? '',
    );
    final String jenisKelaminTarget = normalisasiJenisKelamin(
      targetProfile['jenis_kelamin']?.toString() ?? '',
    );

    int ikhwanId;
    int akhwatId;

    if (jenisKelaminPengaju == genderIkhwan &&
        jenisKelaminTarget == genderAkhwat) {
      ikhwanId = pengajuId;
      akhwatId = targetId;
    } else if (jenisKelaminPengaju == genderAkhwat &&
        jenisKelaminTarget == genderIkhwan) {
      ikhwanId = targetId;
      akhwatId = pengajuId;
    } else {
      return 'Jenis kelamin tidak valid untuk membuat sesi taaruf';
    }

    final now = DateTime.now().toIso8601String();

    await database.transaction((txn) async {
      await txn.update(
        tabelTaarufRequests,
        {'status': statusAccepted, 'updated_at': now},
        where: 'id = ?',
        whereArgs: [requestId],
      );

      final int sesiId = await txn.insert(tabelSesiTaaruf, {
        'taaruf_request_id': requestId,
        'ikhwan_id': ikhwanId,
        'akhwat_id': akhwatId,
        'ustadz_id': ustadzId,
        'status_sesi': statusSesiAktif,
        'created_at': now,
        'updated_at': now,
      });

      await txn.insert(tabelRuangChat, {
        'sesi_taaruf_id': sesiId,
        'nama_ruang': 'Ruang Taaruf #$requestId',
        'created_at': now,
      });
    });

    return null;
  }

  // TOLAK TAARUF REQUEST
  static Future<void> tolakTaarufRequest({required int requestId}) async {
    final database = await db();

    await database.update(
      tabelTaarufRequests,
      {
        'status': statusRejected,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [requestId],
    );
  }

  // UPDATE STATUS TAARUF REQUEST
  static Future<int> updateStatusTaarufRequest({
    required int requestId,
    required String status,
  }) async {
    final database = await db();

    return await database.update(
      tabelTaarufRequests,
      {'status': status, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [requestId],
    );
  }

  // CEK USER DALAM SESI AKTIF
  static Future<bool> userSedangDalamSesiAktif(int userId) async {
    final database = await db();

    final result = await database.query(
      tabelSesiTaaruf,
      where:
          '(ikhwan_id = ? OR akhwat_id = ? OR ustadz_id = ?) AND status_sesi = ?',
      whereArgs: [userId, userId, userId, statusSesiAktif],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // CEK PENGAJUAN PENDING
  static Future<bool> sudahAdaPengajuanPending({
    required int pengajuId,
    required int targetId,
  }) async {
    final database = await db();

    final result = await database.query(
      tabelTaarufRequests,
      where: 'pengaju_id = ? AND target_id = ? AND status = ?',
      whereArgs: [pengajuId, targetId, statusPending],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // GET DATA SERASI
  static Future<List<Map<String, dynamic>>> getSerasiProfiles({
    required int currentUserId,
    required String currentGender,
  }) async {
    final database = await db();

    final String jenisKelaminTarget = targetJenisKelamin(currentGender);

    return await database.rawQuery(
      '''
      SELECT 
        user_profiles.user_id,
        user_profiles.nama_lengkap,
        user_profiles.jenis_kelamin,
        user_profiles.usia,
        user_profiles.domisili,
        user_profiles.pendidikan,
        user_profiles.pekerjaan,
        user_profiles.tentang_saya,
        user_profiles.foto_profil
      FROM user_profiles
      INNER JOIN users ON users.id = user_profiles.user_id
      WHERE user_profiles.is_profile_complete = 1
        AND user_profiles.user_id != ?
        AND LOWER(TRIM(user_profiles.jenis_kelamin)) = LOWER(TRIM(?))
      ORDER BY user_profiles.id DESC
      ''',
      [currentUserId, jenisKelaminTarget],
    );
  }

  // CEK APAKAH STATUS TARGET AKTIF ATAU TIDAK
  static Future<bool> targetSedangDalamSesiAktif(int userId) async {
    final database = await db();

    final result = await database.query(
      tabelSesiTaaruf,
      where:
          '(ikhwan_id = ? OR akhwat_id = ? OR ustadz_id = ?) AND status_sesi = ?',
      whereArgs: [userId, userId, userId, statusSesiAktif],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // VALIDASI SEBELUM AJUKAN TAARUF
  static Future<String?> validateSebelumAjukanTaaruf({
    required int pengajuId,
    required int targetId,
  }) async {
    if (pengajuId == targetId) {
      return 'Tidak bisa mengajukan taaruf ke diri sendiri';
    }

    final profilLengkap = await hasProfile(pengajuId);
    if (!profilLengkap) {
      return 'Lengkapi profil terlebih dahulu sebelum mengajukan taaruf';
    }

    final pengajuSedangAktif = await userSedangDalamSesiAktif(pengajuId);
    if (pengajuSedangAktif) {
      return 'Kamu sedang dalam sesi taaruf aktif';
    }

    final targetSedangAktif = await targetSedangDalamSesiAktif(targetId);
    if (targetSedangAktif) {
      return 'User ini sedang dalam sesi taaruf aktif';
    }

    final sudahPending = await sudahAdaPengajuanPending(
      pengajuId: pengajuId,
      targetId: targetId,
    );

    if (sudahPending) {
      return 'Pengajuan taaruf masih pending untuk user ini';
    }

    return null;
  }

  // DELETE INBOX
  static Future<int> hapusInboxRequest({required int requestId}) async {
    final database = await db();
    return await database.delete(
      tabelTaarufRequests,
      where: 'id = ?',
      whereArgs: [requestId],
    );
  }

  // CREATE SESI TAARUF
  static Future<int> createSesiTaaruf({
    required int taarufRequestId,
    required int ikhwanId,
    required int akhwatId,
    int? ustadzId,
  }) async {
    final database = await db();

    return await database.insert(tabelSesiTaaruf, {
      'taaruf_request_id': taarufRequestId,
      'ikhwan_id': ikhwanId,
      'akhwat_id': akhwatId,
      'ustadz_id': ustadzId,
      'status_sesi': statusSesiAktif,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  // SELESAI SESI TAARUF
  static Future<int> selesaiSesiTaaruf(int sesiId) async {
    final database = await db();

    return await database.update(
      tabelSesiTaaruf,
      {
        'status_sesi': statusSesiSelesai,
        'updated_at': DateTime.now().toIso8601String(),
        'selesai_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [sesiId],
    );
  }

  // CREATE RUANG CHAT
  static Future<int> createRuangChat({
    required int sesiTaarufId,
    required String namaRuang,
  }) async {
    final database = await db();

    return await database.insert(tabelRuangChat, {
      'sesi_taaruf_id': sesiTaarufId,
      'nama_ruang': namaRuang,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // SEND PESAN CHAT
  static Future<int> sendPesanChat({
    required int ruangChatId,
    required int senderId,
    required String pesan,
  }) async {
    final database = await db();

    return await database.insert(tabelPesanChat, {
      'ruang_chat_id': ruangChatId,
      'sender_id': senderId,
      'pesan': pesan,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // GET PESAN CHAT
  static Future<List<Map<String, dynamic>>> getPesanChat(
    int ruangChatId,
  ) async {
    final database = await db();

    return await database.rawQuery(
      '''
      SELECT
        pesan_chat.id,
        pesan_chat.ruang_chat_id,
        pesan_chat.sender_id,
        pesan_chat.pesan,
        pesan_chat.created_at,
        users.nama AS nama_pengirim,
        users.role AS role_pengirim
      FROM pesan_chat
      INNER JOIN users ON users.id = pesan_chat.sender_id
      WHERE pesan_chat.ruang_chat_id = ?
      ORDER BY pesan_chat.id ASC
      ''',
      [ruangChatId],
    );
  }

  static Future<List<Map<String, dynamic>>> getDaftarChatUser(
    int userId,
  ) async {
    final database = await db();

    return await database.rawQuery(
      '''
      SELECT 
        ruang_chat.id AS ruang_chat_id,
        ruang_chat.nama_ruang,
        ruang_chat.created_at,

        sesi_taaruf.id AS sesi_id,
        sesi_taaruf.ikhwan_id,
        sesi_taaruf.akhwat_id,
        sesi_taaruf.ustadz_id,
        sesi_taaruf.status_sesi,

        ikhwan_profile.nama_lengkap AS nama_ikhwan,
        akhwat_profile.nama_lengkap AS nama_akhwat,

        CASE
          WHEN sesi_taaruf.ikhwan_id = ? THEN akhwat_profile.nama_lengkap
          WHEN sesi_taaruf.akhwat_id = ? THEN ikhwan_profile.nama_lengkap
          ELSE ''
        END AS nama_lawan_bicara,

        CASE
          WHEN sesi_taaruf.ikhwan_id = ? THEN akhwat_profile.jenis_kelamin
          WHEN sesi_taaruf.akhwat_id = ? THEN ikhwan_profile.jenis_kelamin
          ELSE ''
        END AS jenis_kelamin_lawan_bicara,

        (
          SELECT pesan
          FROM pesan_chat
          WHERE pesan_chat.ruang_chat_id = ruang_chat.id
          ORDER BY pesan_chat.id DESC
          LIMIT 1
        ) AS pesan_terakhir

      FROM ruang_chat
      INNER JOIN sesi_taaruf
        ON sesi_taaruf.id = ruang_chat.sesi_taaruf_id

      LEFT JOIN user_profiles AS ikhwan_profile
        ON ikhwan_profile.user_id = sesi_taaruf.ikhwan_id

      LEFT JOIN user_profiles AS akhwat_profile
        ON akhwat_profile.user_id = sesi_taaruf.akhwat_id

      WHERE (
        sesi_taaruf.ikhwan_id = ?
        OR sesi_taaruf.akhwat_id = ?
        OR sesi_taaruf.ustadz_id = ?
      )
        AND sesi_taaruf.status_sesi = ?
      ORDER BY ruang_chat.id DESC
      ''',
      [userId, userId, userId, userId, userId, userId, statusSesiAktif],
    );
  }

  // GET RUANG CHAT DARI REQUEST
  static Future<Map<String, dynamic>?> getRuangChatByRequestId(
    int requestId,
  ) async {
    final database = await db();

    final result = await database.rawQuery(
      '''
      SELECT ruang_chat.*
      FROM ruang_chat
      INNER JOIN sesi_taaruf ON sesi_taaruf.id = ruang_chat.sesi_taaruf_id
      WHERE sesi_taaruf.taaruf_request_id = ?
      LIMIT 1
      ''',
      [requestId],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }
}
