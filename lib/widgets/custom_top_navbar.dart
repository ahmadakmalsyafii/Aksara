import 'package:aksara/views/bookmark/bookmark_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTopNavbar extends StatelessWidget {
  final String username;
  final int streak;

  const CustomTopNavbar({super.key, required this.username, required this.streak});

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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50)
              ),
              child:
              Row(
                children: [
                  Icon(Icons.local_fire_department, color: Colors.orange),
                  SizedBox(width: 4),
                  Text("$streak"),
                ],
              ),
            ),

            SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookmarkPage()),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.bookmark_border_rounded, color: Colors.black),
              ),
            ),
          ],
        )
      ],
    );
  }
}
