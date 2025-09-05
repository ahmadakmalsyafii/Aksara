import 'package:aksara/widgets/google_button.dart';
import 'package:aksara/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:aksara/services/auth_service.dart';
import 'package:aksara/views/auth/login_page.dart';
import 'package:aksara/widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool agree = false;

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
              const Text("Daftarkan Akun",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Text("Daftarkan akun Anda untuk mulai belajar"),
              const SizedBox(height: 20),
              CustomTextField(
                hint: "Username",
                icon: Icons.person_outline_rounded,
                controller: usernameController,
              ),
              const SizedBox(height: 10),
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
              CustomTextField(
                hint: "Konfirmasi Kata Sandi",
                icon: Icons.lock_outline_rounded,
                obscure: true,
                controller: confirmPasswordController,
              ),
              Row(
                children: [
                  Checkbox(
                    value: agree,
                    onChanged: (val) {
                      setState(() {
                        agree = val ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "You have read, understood, and agree to our Terms & Privacy Policy.",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              PrimaryButton(
                text: "Daftar",
                onPressed: () async {
                  if (!agree) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Harap setujui Terms & Privacy Policy")),
                    );
                    return;
                  }

                  if (passwordController.text != confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Password tidak sama")),
                    );
                    return;
                  }

                  var user = await authService.registerWithEmail(
                    usernameController.text,
                    emailController.text,
                    passwordController.text,
                  );
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Registrasi berhasil!")),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sudah mempunyai akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text("Masuk"),
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
                text: "Daftar dengan Google",
                onPressed: () async {
                  var user = await authService.signInWithGoogle();
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Daftar dengan Google berhasil!")),
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
