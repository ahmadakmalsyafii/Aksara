import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            currentIndex == 0
                ? "assets/icons/home_active.svg"
                : "assets/icons/home_inactive.svg",
            width: 28,
            height: 28,
          ),
          label: "Beranda",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            currentIndex == 1
                ? "assets/icons/riwayat_active.svg"
                : "assets/icons/riwayat_inactive.svg",
            width: 28,
            height: 28,
          ),
          label: "Riwayat",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            currentIndex == 2
                ? "assets/icons/saloka_active.svg"
                : "assets/icons/saloka_inactive.svg",
            width: 28,
            height: 28,
          ),
          label: "Saloka",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            currentIndex == 3
                ? "assets/icons/profile_active.svg"
                : "assets/icons/profile_inactive.svg",
            width: 28,
            height: 28,
          ),
          label: "Profil",
        ),
      ],
    );
  }
}
