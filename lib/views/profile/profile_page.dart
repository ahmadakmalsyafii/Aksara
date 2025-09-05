// lib/views/profile/profile_page.dart

import 'package:aksara/models/user_model.dart';
import 'package:aksara/services/auth_service.dart';
import 'dart:collection';
import 'package:aksara/services/history_service.dart';
import 'package:aksara/services/user_service.dart';
import 'package:aksara/services/user_stats_service.dart';
import 'package:aksara/views/auth/login_page.dart';
import 'package:aksara/widgets/account_setting_card.dart';
import 'package:aksara/widgets/general_settings_card.dart';
import 'package:aksara/widgets/profile_header.dart';
import 'package:aksara/widgets/stats_card.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  final StatsService _statsService = StatsService();
  final HistoryService _historyService = HistoryService();
  final AuthService _authService = AuthService();

  Future<void> _showLogoutConfirmationBottomSheet(BuildContext context) async {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('assets/images/bye_mascot.png', height: 150),
                const SizedBox(height: 16),
                const Text(
                  'Keluar dari Aplikasi?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Kamu yakin ingin keluar? Semua data tetap aman dan bisa diakses kembali saat login.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Ga jadi keluar deh'),
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                  },
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text('Ya, aku mau keluar'),
                  onPressed: () async {
                    Navigator.of(sheetContext).pop();
                    await _authService.signOut();


                    if (mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                            (Route<dynamic> route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<Map<String, dynamic>> _fetchProfileData() async {
    final user = await _userService.getCurrentUser();
    final stats = await _statsService.getStats();
    final history = await _historyService.getHistory();
    final booksRead = HashSet<String>.from(history.map((h) => h.bookId)).length;

    return {
      'user': user,
      'points': stats?['points'] ?? 0,
      'streak': stats?['streak'] ?? 0,
      'booksRead': booksRead,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Gagal memuat data profil"));
          }

          final data = snapshot.data!;
          final UserModel? user = data['user'];
          final int points = data['points'];
          final int streak = data['streak'];
          final int booksRead = data['booksRead'];

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            // Menggunakan ListView untuk menghindari overflow
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
              children: [
                ProfileHeader(user: user),
                const SizedBox(height: 20),
                StatsCard(points: points, streak: streak, booksRead: booksRead),
                const SizedBox(height: 24),
                AccountSettingsCard(onProfileEdited: () => setState(() {})),
                const SizedBox(height: 16),
                GeneralSettingsCard(onLogout: () => _showLogoutConfirmationBottomSheet(context)),
              ],
            ),
          );
        },
      ),
    );
  }
}