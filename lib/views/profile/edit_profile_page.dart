// lib/views/profile/edit_profile_page.dart

import 'package:aksara/models/user_model.dart';
import 'package:aksara/services/user_service.dart';
import 'package:aksara/views/profile/update_success_page.dart';
import 'package:aksara/widgets/edit_profile_form.dart';
import 'package:aksara/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _classController;
  late TextEditingController _majorController;
  late TextEditingController _dobController;

  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _classController = TextEditingController();
    _majorController = TextEditingController();
    _dobController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    _currentUser = await _userService.getCurrentUser();
    if (_currentUser != null) {
      _nameController.text = _currentUser!.username;
      _emailController.text = _currentUser!.email;
      _classController.text = _currentUser!.kelas ?? '';
      _majorController.text = _currentUser!.peminatan ?? '';
      _dobController.text = _currentUser!.tanggalLahir ?? '';
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _classController.dispose();
    _majorController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate() && _currentUser != null) {
      setState(() => _isLoading = true);
      final updatedUser = _currentUser!.copyWith(
        username: _nameController.text,
        kelas: _classController.text,
        peminatan: _majorController.text,
        tanggalLahir: _dobController.text,
      );

      await _userService.updateUserData(updatedUser);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const SuccessPage(
              title: "Profil Berhasil Diubah",
              message: "Profil telah berhasil diperbarui",
              buttonText: "Kembali ke profil",
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade200,
            child: _currentUser?.photoUrl != null
                ? ClipOval(child: Image.network(_currentUser!.photoUrl!, fit: BoxFit.cover))
                : Icon(Icons.person, size: 50, color: Colors.grey.shade400),
          ),
          TextButton(
            onPressed: () { /* TODO: Implementasi ubah foto */ },
            child: const Text("Ubah Foto"),
          ),
          const SizedBox(height: 24),

          // --- Memanggil Widget Form ---
          EditProfileForm(
            formKey: _formKey,
            nameController: _nameController,
            emailController: _emailController,
            classController: _classController,
            majorController: _majorController,
            dobController: _dobController,
          ),
          const SizedBox(height: 24),

          // --- Tombol Aksi Tetap di Sini ---
          PrimaryButton(text: "Simpan Perubahan", onPressed: _saveProfile),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () { /* Logic for delete account */ },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              side: const BorderSide(color: Colors.red),
            ),
            child: const Text("Hapus Akun", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}