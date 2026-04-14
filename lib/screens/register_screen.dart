import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/controllers/auth_controller.dart';
import 'package:zawj_app/extention/navigator.dart';
import 'package:zawj_app/screens/login_screen.dart';
import 'package:zawj_app/widgets/app_color.dart';
import 'package:zawj_app/widgets/custom_button.dart';
import 'package:zawj_app/widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = AuthController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String pesan) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(pesan), behavior: SnackBarBehavior.floating),
      );
  }

  Future<void> _handleRegister() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final result = await _authController.register(
      nama: _namaController.text,
      email: _emailController.text,
      password: _passwordController.text,
      konfirmasiPassword: _konfirmasiPasswordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result != null) {
      _showSnackBar(result);
      return;
    }

    _showSnackBar('Pendaftaran berhasil, silakan login');

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    context.pushReplacement(const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              'Find My Zawj',
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE76CA3),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.favorite,
              color: Color.fromARGB(255, 239, 97, 144),
              size: 24,
            ),
          ],
        ),
      ),
      body: FadeInDown(
        duration: const Duration(milliseconds: 800),
        delay: const Duration(milliseconds: 400),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Selamat Datang",
                  style: GoogleFonts.montaga(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: AppColor.pinktua,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Daftar untuk memulai perjalanan menuju pernikahan yang berkah",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: AppColor.hitam,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _namaController,
                  decoration: customTextField(
                    hintText: 'Nama Lengkap',
                  ).copyWith(prefixIcon: const Icon(Icons.person)),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: customTextField(
                    hintText: 'Email',
                  ).copyWith(prefixIcon: const Icon(Icons.email_outlined)),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isPasswordHidden,
                  decoration: customTextField(hintText: 'Password').copyWith(
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _konfirmasiPasswordController,
                  obscureText: _isConfirmPasswordHidden,
                  decoration: customTextField(hintText: 'Konfirmasi Password')
                      .copyWith(
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordHidden =
                                  !_isConfirmPasswordHidden;
                            });
                          },
                        ),
                      ),
                ),
                const SizedBox(height: 35),
                _isLoading
                    ? const CircularProgressIndicator()
                    : customButton(
                        text: 'Daftar',
                        onPressed: _handleRegister,
                        width: 300,
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sudah punya akun? ",
                      style: GoogleFonts.montaga(
                        fontSize: 14,
                        color: AppColor.hitam,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.pushReplacement(const LoginScreen());
                      },
                      child: Text(
                        "Masuk",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColor.pinktua,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
