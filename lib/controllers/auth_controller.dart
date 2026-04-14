import 'package:zawj_app/database/sqflite.dart';
import 'package:zawj_app/models/user_model.dart';
import 'package:zawj_app/services/preference_handler.dart';

class LoginResult {
  final bool success;
  final String? message;
  final UserModel? user;

  LoginResult({required this.success, this.message, this.user});
}

class AuthController {
  Future<String?> register({
    required String nama,
    required String email,
    required String password,
    required String konfirmasiPassword,
  }) async {
    final namaBersih = nama.trim();
    final emailBersih = email.trim().toLowerCase();
    final passwordBersih = password.trim();
    final konfirmasiBersih = konfirmasiPassword.trim();

    if (namaBersih.isEmpty ||
        emailBersih.isEmpty ||
        passwordBersih.isEmpty ||
        konfirmasiBersih.isEmpty) {
      return 'Semua field harus diisi';
    }

    if (!emailBersih.contains('@gmail.com')) {
      return 'Format email tidak valid';
    }

    if (passwordBersih.length < 6) {
      return 'Password minimal 6 karakter';
    }

    if (passwordBersih != konfirmasiBersih) {
      return 'Konfirmasi password tidak sama';
    }

    final emailSudahAda = await DBHelper.isEmailExists(emailBersih);
    if (emailSudahAda) {
      return 'Email sudah terdaftar';
    }

    final user = UserModel(
      nama: namaBersih,
      email: emailBersih,
      password: passwordBersih,
      role: 'user',
    );

    await DBHelper.registerUser(user);

    return null;
  }

  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    final emailBersih = email.trim().toLowerCase();
    final passwordBersih = password.trim();

    if (emailBersih.isEmpty || passwordBersih.isEmpty) {
      return LoginResult(
        success: false,
        message: 'Email dan password wajib diisi',
      );
    }

    final user = await DBHelper.loginUser(
      email: emailBersih,
      password: passwordBersih,
    );

    if (user == null) {
      return LoginResult(success: false, message: 'Email atau password salah');
    }

    await PreferenceHandler.simpanLogin(
      userId: user.id!,
      nama: user.nama,
      email: user.email,
      role: user.role,
    );

    return LoginResult(success: true, user: user);
  }

  Future<void> logout() async {
    await PreferenceHandler.logout();
  }
}
