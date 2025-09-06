// lib/views/auth/login_page.dart
import 'package:aksara/main.dart';
import 'package:aksara/views/auth/lupa_password_page.dart';
import 'package:aksara/widgets/google_button.dart';
import 'package:flutter/material.dart';
import 'package:aksara/services/auth_service.dart';
import 'package:aksara/views/auth/register_page.dart';
import 'package:aksara/widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  bool _loginFailed = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateFields);
    passwordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    emailController.removeListener(_validateFields);
    passwordController.removeListener(_validateFields);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _isButtonEnabled =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  void _loginUser() async {
    setState(() {
      _isLoading = true;
      _loginFailed = false;
    });
    var user = await authService.loginWithEmail(
      emailController.text,
      passwordController.text,
    );
    if (mounted) {
      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthWrapper()),
              (route) => false,
        );
      } else {
        setState(() {
          _loginFailed = true;
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
  }



  void _googleSignIn() async {
    setState(() => _isLoading = true);
    var user = await authService.signInWithGoogle();
    if (mounted) {
      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthWrapper()),
              (route) => false,
        );
      } else {
        setState(() {
          _loginFailed = true;
        });
      }
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Container(
                alignment: Alignment.center,
                child: Image.asset('assets/images/aksara_icon.png'),
              ),
              const SizedBox(height: 40),
              if (_loginFailed)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Login gagal. Periksa kembali email dan kata sandi Anda.",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              const Text("Selamat Datang!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Text("Masuk ke akun Anda untuk mulai belajar"),

              const SizedBox(height: 20),
              CustomTextField(
                hint: "E-mail",
                icon: Icons.email_outlined,
                controller: emailController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hint: "Kata Sandi",
                icon: Icons.lock_outline_rounded,
                obscure: true,
                controller: passwordController,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LupaPasswordPage()),
                    );
                  },
                  child: const Text("Lupa Kata Sandi?"),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: _isButtonEnabled
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                onPressed:
                _isButtonEnabled ? (_isLoading ? null : _loginUser) : null,
                child: Text(
                  _isLoading ? "Masuk..." : "Masuk",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum mempunyai akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text("Daftar"),
                  )
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "Atau dengan",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GoogleButton(
                text: "Masuk dengan Google",
                onPressed: _isLoading ? () {} : _googleSignIn,
              )
            ],
          ),
        ),
      ),
    );
  }
}