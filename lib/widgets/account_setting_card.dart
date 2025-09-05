import 'package:aksara/views/profile/account_security_page.dart';
import 'package:aksara/views/profile/edit_profile_page.dart';
import 'package:flutter/material.dart';

class AccountSettingsCard extends StatelessWidget {
  final VoidCallback onProfileEdited;
  const AccountSettingsCard({super.key, required this.onProfileEdited});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pengaturan Akun", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text("Keamanan Akun"),
              subtitle: const Text("E-mail, Kata sandi"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountSecurityPage()));
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text("Edit Profil"),
              subtitle: const Text("Atur informasi pribadi"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage()))
                    .then((_) => onProfileEdited());
              },
            ),
          ],
        ),
      ),
    );
  }
}