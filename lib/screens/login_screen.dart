import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/controllers/auth_controller.dart';
import 'package:zawj_app/extention/navigator.dart';
import 'package:zawj_app/screens/navbar.dart';
import 'package:zawj_app/screens/register_screen.dart';
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

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _authController.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (result == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login berhasil')));

      context.pushAndRemoveAll(Navbar());
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
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
                  const SizedBox(height: 50),
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

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Lupa Password?",
                        style: TextStyle(color: AppColor.pinktua, fontSize: 14),
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

                  const SizedBox(height: 30),

                  Text(
                    "Atau lanjutkan dengan",
                    style: GoogleFonts.montaga(
                      color: AppColor.abumuda,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {},
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.abumuda,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/icons/google.png',
                              width: 28,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {},
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.abumuda,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/icons/apple.png',
                              width: 28,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {},
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.abumuda,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/icons/facebook.png',
                              width: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum Punya Akun? ",
                        style: GoogleFonts.montaga(
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
