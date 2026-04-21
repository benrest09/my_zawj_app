import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/controllers/auth_controller.dart';
import 'package:zawj_app/extention/navigator.dart';
import 'package:zawj_app/screens/navbar.dart';
import 'package:zawj_app/screens/register_screen.dart';
import 'package:zawj_app/screens/ustadz_chat_screen.dart';
import 'package:zawj_app/widgets/app_color.dart';
import 'package:zawj_app/widgets/custom_button.dart';
import 'package:zawj_app/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = AuthController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String pesan) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(pesan), behavior: SnackBarBehavior.floating),
      );
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final result = await _authController.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (!result.success) {
      _showSnackBar(result.message ?? 'Login gagal');
      return;
    }

    final user = result.user;
    if (user == null) {
      _showSnackBar('Data user tidak ditemukan');
      return;
    }

    _showSnackBar('Login berhasil');

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    if (user.role == 'ustadz') {
      context.pushAndRemoveAll(const UstadzChatScreen());
    } else {
      context.pushAndRemoveAll(Navbar());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
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
      body: FadeInUp(
        duration: const Duration(milliseconds: 800),
        delay: const Duration(milliseconds: 400),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 150),
                  Text(
                    "Selamat Datang",
                    style: GoogleFonts.montaga(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColor.pinktua,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Masuk untuk melanjutkan perjalanan menuju pernikahan yang berkah.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: AppColor.abumuda,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailController,
                    decoration: customTextField(
                      hintText: 'Email',
                    ).copyWith(prefixIcon: const Icon(Icons.email_outlined)),
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : customButton(
                          text: 'Masuk',
                          width: double.infinity,
                          onPressed: _handleLogin,
                        ),
                  const SizedBox(height: 20),

                  // GestureDetector(
                  //   onTap: () async {
                  //     final result = await _authController.loginWithGoogle();

                  //     if (!result.success) {
                  //       _showSnackBar(result.message ?? 'Login Google gagal');
                  //       return;
                  //     }

                  //     _showSnackBar('Login Google berhasil');

                  //     await Future.delayed(const Duration(milliseconds: 600));

                  //     if (!mounted) return;

                  //     if (result.user!.role == 'ustadz') {
                  //       context.pushAndRemoveAll(const UstadzChatScreen());
                  //     } else {
                  //       context.pushAndRemoveAll(Navbar());
                  //     }
                  //   },
                  //   child: Container(
                  //     width: double.infinity,
                  //     padding: const EdgeInsets.symmetric(vertical: 12),
                  //     decoration: BoxDecoration(
                  //       border: Border.all(color: Colors.grey.shade300),
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Colors.white,
                  //     ),
                  // //     child: Row(
                  // //       mainAxisAlignment: MainAxisAlignment.center,
                  // //       children: [
                  // //         Image.asset('assets/icons/google.png', height: 20),
                  // //         const SizedBox(width: 10),
                  // //         Text(
                  // //           "Masuk dengan Google",
                  // //           style: GoogleFonts.montserrat(
                  // //             fontSize: 14,
                  // //             fontWeight: FontWeight.w600,
                  // //             color: Colors.black87,
                  // //           ),
                  // //         ),
                  // //       ],
                  // //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum Punya Akun? ",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: AppColor.abumuda,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.pushReplacement(const RegisterScreen());
                        },
                        child: Text(
                          "Daftar",
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.pinktua,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
