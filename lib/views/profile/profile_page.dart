// lib/views/profile/profile_page.dart

import 'package:aksara/models/history_model.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<UserModel?>(
        stream: _userService.getCurrentUserStream(),
        builder: (context, userSnapshot) {
          return StreamBuilder<Map<String, dynamic>>(
            stream: _statsService.getStatsStream(),
            builder: (context, statsSnapshot) {
              return StreamBuilder<List<HistoryModel>>(
                stream: _historyService.getHistoryStream(),
                builder: (context, historySnapshot) {
                  if (!userSnapshot.hasData ||
                      !statsSnapshot.hasData ||
                      !historySnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final UserModel? user = userSnapshot.data;
                  final stats = statsSnapshot.data!;
                  final history = historySnapshot.data!;

                  final int points = stats['points'] ?? 0;
                  final int streak = stats['streak'] ?? 0;
                  final int booksRead =
                      HashSet<String>.from(history.map((h) => h.bookId))
                          .length;

                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
                      children: [
                        ProfileHeader(user: user),
                        const SizedBox(height: 20),
                        StatsCard(
                            points: points,
                            streak: streak,
                            booksRead: booksRead),
                        const SizedBox(height: 24),
                        AccountSettingsCard(
                            onProfileEdited: () => setState(() {})),
                        const SizedBox(height: 16),
                        GeneralSettingsCard(
                            onLogout: () =>
                                _showLogoutConfirmationBottomSheet(context)),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}