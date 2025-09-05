import 'package:aksara/views/auth/lupa_password_page.dart';
import 'package:aksara/widgets/google_button.dart';
import 'package:aksara/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:aksara/services/auth_service.dart';
import 'package:aksara/views/auth/register_page.dart';
import 'package:aksara/widgets/custom_textfield.dart';
import 'package:aksara/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

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
                      MaterialPageRoute(builder: (_) =>  ForgotPasswordPage()),
                    );
                  },
                  child: const Text("Lupa Kata Sandi?"),
                ),
              ),
              PrimaryButton(
                text: "Masuk",
                onPressed: () async {
                  var user = await authService.loginWithEmail(
                    emailController.text,
                    passwordController.text,
                  );
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login berhasil!")),
                    );
                  }
                },
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
              SizedBox(height:20,),
              GoogleButton(
                text: "Masuk dengan Google",
                onPressed: () async {
                  var user = await authService.signInWithGoogle();
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login dengan Google berhasil!")),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
