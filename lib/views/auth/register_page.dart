// lib/views/auth/register_page.dart
import 'package:aksara/widgets/google_button.dart';
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
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool agree = false;
  bool _isLoading = false;
  bool _isButtonEnabled = false;

  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    usernameController.addListener(_validateFields);
    emailController.addListener(_validateFields);
    passwordController.addListener(_validateFields);
    confirmPasswordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    usernameController.removeListener(_validateFields);
    emailController.removeListener(_validateFields);
    passwordController.removeListener(_validateFields);
    confirmPasswordController.removeListener(_validateFields);
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _isButtonEnabled = usernameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty;
    });
  }

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      if (!agree) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Harap setujui Terms & Privacy Policy")),
        );
        return;
      }
      setState(() => _isLoading = true);
      var user = await authService.registerWithEmail(
        usernameController.text,
        emailController.text,
        passwordController.text,
      );
      if (mounted) {
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registrasi berhasil!")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Gagal mendaftar. Email mungkin sudah digunakan atau terjadi kesalahan lain.")),
          );
        }
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                    style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const Text("Daftarkan akun Anda untuk mulai belajar"),
                const SizedBox(height: 20),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: "Username",
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "E-mail",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Masukkan format email yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Kata Sandi",
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Kata sandi minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Konfirmasi Kata Sandi",
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi kata sandi';
                    }
                    if (value != passwordController.text) {
                      return 'Kata sandi tidak cocok';
                    }
                    return null;
                  },
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
                  _isButtonEnabled ? (_isLoading ? null : _registerUser) : null,
                  child: Text(
                    _isLoading ? "Mendaftar..." : "Daftar",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
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
                  text: "Daftar dengan Google",
                  onPressed: () async {
                    var user = await authService.signInWithGoogle();
                    if (user != null && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Daftar dengan Google berhasil!")),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}