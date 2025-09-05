// lib/views/auth/choose_class_page.dart
import 'package:aksara/services/user_service.dart';
import 'package:aksara/views/main_page.dart';
import 'package:flutter/material.dart';

class ChooseClassPage extends StatefulWidget {
  const ChooseClassPage({super.key});

  @override
  State<ChooseClassPage> createState() => _ChooseClassPageState();
}

class _ChooseClassPageState extends State<ChooseClassPage> {
  final UserService _userService = UserService();
  String? _selectedClass;

  final List<String> classes = [
    'Kelas 5', 'Kelas 6', 'Kelas 7', 'Kelas 8', 'Kelas 9',
    'Kelas 10 IPA', 'Kelas 10 IPS', 'Kelas 11 IPA', 'Kelas 11 IPS',
    'Kelas 12 IPA', 'Kelas 12 IPS'
  ];

  void _saveClassAndProceed() async {
    if (_selectedClass != null) {
      final user = await _userService.getCurrentUser();
      if (user != null) {
        final updatedUser = user.copyWith(kelas: _selectedClass);
        await _userService.updateUserData(updatedUser);
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
                (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Image.asset('assets/images/app_icon.png', height: 50,)],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hai, Raioners!',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Yuk, pilih kelas dan kurikulum kamu sebelum belajar.',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/success_mascot.png', // Sesuaikan path jika perlu
                height: 180,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    alignment: WrapAlignment.center,
                    children: classes.map((className) {
                      final isSelected = _selectedClass == className;
                      return ChoiceChip(
                        label: Text(className),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedClass = selected ? className : null;
                          });
                        },
                        selectedColor: Theme.of(context).primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : Colors.grey.shade300,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: _selectedClass != null
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                onPressed: _selectedClass != null ? _saveClassAndProceed : null,
                child: const Text(
                  'Simpan Pilihan',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}