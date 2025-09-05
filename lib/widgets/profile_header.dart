// lib/views/profile/widgets/profile_header.dart

import 'package:aksara/models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel? user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey.shade200,
          child: user?.photoUrl != null
              ? ClipOval(child: Image.network(user!.photoUrl!, fit: BoxFit.cover))
              : Icon(Icons.person, size: 50, color: Colors.grey.shade400),
        ),
        const SizedBox(height: 12),
        Text(
          user?.username ?? 'Pengguna',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          'Kelas ${user?.kelas ?? '-'} - ${user?.peminatan ?? '-'}',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ],
    );
  }
}