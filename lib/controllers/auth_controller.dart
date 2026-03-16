import 'package:zawj_app/database/sqflite.dart';
import 'package:zawj_app/models/user_model.dart';
import 'package:zawj_app/services/preference_handler.dart';

class AuthController {
  Future<String?> register({
    required String nama,
    required String email,
    required String password,
    required String konfirmasiPassword,
  }) async {
    if (nama.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty ||
        konfirmasiPassword.trim().isEmpty) {
      return 'Semua field harus diisi';
    }

    if (!email.contains('@gmail.com')) {
      return 'Format email tidak valid';
    }

    if (password.length < 6) {
      return 'Password miinmal 6 karakter';
    }

    if (password != konfirmasiPassword) {
      return 'Konfirmasi password tidak sama';
    }

    final emailSudahAda = await DBHelper.isEmailExists(email);
    if (emailSudahAda) {
      return 'Email sudah terdaftar';
    }

    final user = UserModel(nama: nama, email: email, password: password);

    await DBHelper.registerUser(user);

    return null;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      return 'Email dan password wajib diisi';
    }

    final user = await DBHelper.loginUser(email: email, password: password);

    if (user == null) {
      return 'Email atau password salah';
    }

    await PreferenceHandler.simpanLogin(
      userId: user.id!,
      nama: user.nama,
      email: user.email,
    );

    return null;
  }

  Future<void> logout() async {
    await PreferenceHandler.logout();
  }
}
