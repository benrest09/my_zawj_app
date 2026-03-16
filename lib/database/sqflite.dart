import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zawj_app/models/user_model.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> db() async {
    if (_database != null) return _database!;
    _database = await _initDB();
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
        // USERS
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

        // USER PROFILES
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

        // TAARUF REQUESTS
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

        //SESI TAARUF
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

        // RUANG CHAT
        await db.execute('''
          CREATE TABLE ruang_chat (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sesi_taaruf_id INTEGER NOT NULL UNIQUE,
            nama_ruang TEXT,
            created_at TEXT,

            FOREIGN KEY (sesi_taaruf_id) REFERENCES sesi_taaruf(id) ON DELETE CASCADE ON UPDATE CASCADE
          )
        ''');

        // PESAN CHAT
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

        // INDEX
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

  // REGISTER USER
  static Future<int> registerUser(UserModel user) async {
    final database = await db();
    return await database.insert('users', user.toMap());
  }

  // LOGIN USER
  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final database = await db();

    final results = await database.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
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
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    return result.isNotEmpty;
  }

  // CREATE PROFILE
  static Future<int> createProfile(Map<String, dynamic> profile) async {
    final database = await db();
    return await database.insert('user_profiles', profile);
  }

  // GET PROFILE BY USER ID
  static Future<Map<String, dynamic>?> getProfileByUserId(int userId) async {
    final database = await db();

    final result = await database.query(
      'user_profiles',
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
      'user_profiles',
      data,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // HAS PROFILE
  static Future<bool> hasProfile(int userId) async {
    final database = await db();

    final result = await database.query(
      'user_profiles',
      where: 'user_id = ? AND is_profile_complete = 1',
      whereArgs: [userId],
    );

    return result.isNotEmpty;
  }

  //CREATE TAARUF REQUEST
  static Future<int> createTaarufRequest({
    required int pengajuId,
    required int targetId,
    String? pesanPengajuan,
  }) async {
    final database = await db();

    return await database.insert('taaruf_requests', {
      'pengaju_id': pengajuId,
      'target_id': targetId,
      'status': 'pending',
      'pesan_pengajuan': pesanPengajuan,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  // GET TAARUF REQUESTS
  static Future<List<Map<String, dynamic>>> getTaarufRequests(
    int userId,
  ) async {
    final database = await db();

    return await database.query(
      'taaruf_requests',
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
      'user_profiles',
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
      'taaruf_requests',
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

    final String pengajuGender =
        pengajuProfile['jenis_kelamin']?.toString() ?? '';
    final String targetGender =
        targetProfile['jenis_kelamin']?.toString() ?? '';

    int ikhwanId;
    int akhwatId;

    if (pengajuGender == 'Ikhwan' && targetGender == 'Akhwat') {
      ikhwanId = pengajuId;
      akhwatId = targetId;
    } else if (pengajuGender == 'Akhwat' && targetGender == 'Ikhwan') {
      ikhwanId = targetId;
      akhwatId = pengajuId;
    } else {
      return 'Jenis kelamin tidak valid untuk membuat sesi taaruf';
    }

    await database.transaction((txn) async {
      await txn.update(
        'taaruf_requests',
        {'status': 'accepted', 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [requestId],
      );

      await txn.insert('sesi_taaruf', {
        'taaruf_request_id': requestId,
        'ikhwan_id': ikhwanId,
        'akhwat_id': akhwatId,
        'status_sesi': 'aktif',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    });

    return null;
  }

  // TOLAK TAARUF REQUEST
  static Future<void> tolakTaarufRequest({required int requestId}) async {
    final database = await db();

    await database.update(
      'taaruf_requests',
      {'status': 'rejected', 'updated_at': DateTime.now().toIso8601String()},
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
      'taaruf_requests',
      {'status': status, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [requestId],
    );
  }

  // CEK USER DALAM SESI AKTIF
  static Future<bool> userSedangDalamSesiAktif(int userId) async {
    final database = await db();

    final result = await database.query(
      'sesi_taaruf',
      where: '(ikhwan_id = ? OR akhwat_id = ?) AND status_sesi = ?',
      whereArgs: [userId, userId, 'aktif'],
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
      'taaruf_requests',
      where: 'pengaju_id = ? AND target_id = ? AND status = ?',
      whereArgs: [pengajuId, targetId, 'pending'],
    );

    return result.isNotEmpty;
  }

  //get data serasi
  static Future<List<Map<String, dynamic>>> getSerasiProfiles({
    required int currentUserId,
    required String currentGender,
  }) async {
    final database = await db();

    String targetGender = currentGender == 'Ikhwan' ? 'Akhwat' : 'Ikhwan';

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
      AND user_profiles.jenis_kelamin = ?
    ORDER BY user_profiles.id DESC
  ''',
      [currentUserId, targetGender],
    );
  }

  //CEK APAKAH STATUS TARGET AKTIF ATAU TIDAK
  static Future<bool> targetSedangDalamSesiAktif(int userId) async {
    final database = await db();

    final result = await database.query(
      'sesi_taaruf',
      where: '(ikhwan_id = ? OR akhwat_id = ?) AND status_sesi = ?',
      whereArgs: [userId, userId, 'aktif'],
    );

    return result.isNotEmpty;
  }

  //VALIDASI SEBELUM AJUKAN TAARUF
  static Future<String?> validateSebelumAjukanTaaruf({
    required int pengajuId,
    required int targetId,
  }) async {
    if (pengajuId == targetId) {
      return 'Tidak bisa mengajukan taaruf ke diri sendiri';
    }

    final profileLengkap = await hasProfile(pengajuId);
    if (!profileLengkap) {
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

  //DELETE INBOX
  static Future<int> hapusInboxRequest({required int requestId}) async {
    final database = await db();
    return await database.delete(
      'taaruf_requests',
      where: 'id = ?',
      whereArgs: [requestId],
    );
  }
}
