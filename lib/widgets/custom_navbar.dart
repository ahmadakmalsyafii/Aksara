import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNavbar extends StatelessWidget {
  final String username;
  final int streak;

  const CustomNavbar({super.key, required this.username, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Halo, $username", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Selamat Belajar!", style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        Row(
          children: [
            Icon(Icons.local_fire_department, color: Colors.orange),
            SizedBox(width: 4),
            Text("$streak"),
            SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: SvgPicture.asset('assets/icons/readlist_icon.svg'),
            ),
          ],
        )
      ],
    );
  }
}
