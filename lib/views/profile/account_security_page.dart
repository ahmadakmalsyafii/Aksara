import 'package:aksara/services/auth_service.dart';
import 'package:aksara/views/profile/update_success_page.dart';
import 'package:aksara/widgets/custom_textfield.dart';
import 'package:aksara/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountSecurityPage extends StatefulWidget {
  const AccountSecurityPage({super.key});

  @override
  State<AccountSecurityPage> createState() => _AccountSecurityPageState();
}

class _AccountSecurityPageState extends State<AccountSecurityPage> {
  final _authService = AuthService();
  final _currentUser = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (_currentUser != null) {
      _emailController.text = _currentUser!.email ?? '';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final result = await _authService.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (mounted) {
        if (result) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const SuccessPage(
                title: "Kata Sandi Berhasil Diubah",
                message: "Kata sandi telah berhasil diperbarui",
                buttonText: "Kembali ke profil",
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal mengubah kata sandi. Periksa kembali kata sandi Anda saat ini.")),
          );
        }
      }

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keamanan Akun")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("Ubah Foto"),
              ),
              const SizedBox(height: 24),
              _buildTextField(label: "E-mail", controller: _emailController, readOnly: true),
              _buildTextField(label: "Kata Sandi Sekarang", controller: _currentPasswordController, obscureText: true, hint: 'Masukkan kata sandi sekarang'),
              _buildTextField(label: "Kata Sandi Baru", controller: _newPasswordController, obscureText: true, hint: 'Minimal 8 karakter'),
              const SizedBox(height: 32),
              PrimaryButton(
                text: _isLoading ? "Menyimpan..." : "Simpan Perubahan",
                onPressed: _isLoading ? () {} : _changePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    bool obscureText = false,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: readOnly ? null : const Icon(Icons.edit_outlined, size: 20),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label tidak boleh kosong';
              }
              if (!readOnly && obscureText && value.length < 8) {
                return 'Kata sandi minimal 8 karakter';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}