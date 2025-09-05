import 'package:aksara/views/profile/faq_page.dart';
import 'package:flutter/material.dart';

class GeneralSettingsCard extends StatelessWidget {
  final VoidCallback onLogout;
  const GeneralSettingsCard({super.key, required this.onLogout});

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
            const Text("Pengaturan Umum", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("FAQ"),
              subtitle: const Text("Cari pertanyaan anda"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FaqPage()));
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Bahasa"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Indonesia", style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {},
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.brightness_6_outlined),
              title: const Text("Tema"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Terang", style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {},
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Keluar", style: TextStyle(color: Colors.red)),
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}