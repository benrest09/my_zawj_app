import 'package:zawj_app/services/firebase_service.dart';
import 'package:zawj_app/models/user_model_firebase.dart';

class LoginResult {
  final bool success;
  final String? message;
  final UserModelFirebase? user;

  LoginResult({required this.success, this.message, this.user});
}

class AuthController {
  Future<String?> register({
    required String nama,
    required String email,
    required String password,
    required String konfirmasiPassword,
  }) async {
    final emailFix = email.trim().toLowerCase();

    if (password != konfirmasiPassword) {
      return 'Konfirmasi password tidak sama';
    }

    final (user, error) = await FirebaseService.registerUser(
      email: emailFix,
      password: password,
      username: nama,
    );

    if (error != null) return error;

    return null;
  }

  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    final emailFix = email.trim().toLowerCase();

    final (user, error) = await FirebaseService.loginUser(
      email: emailFix,
      password: password,
    );

    if (error != null) {
      return LoginResult(success: false, message: error);
    }

    return LoginResult(success: true, user: user!);
  }

  Future<LoginResult> loginWithGoogle() async {
    final (user, error) = await FirebaseService.loginWithGoogle();

    if (error != null) {
      return LoginResult(success: false, message: error);
    }

    return LoginResult(success: true, user: user!);
  }

  Future<void> logout() async {
    await FirebaseService.logout();
  }
}
