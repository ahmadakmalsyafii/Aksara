// lib/views/splash_screen.dart
import 'package:aksara/main.dart'; // Import MyApp atau OnboardingOrAuthWrapper
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<String> _splashImages = [
    'assets/splash/splash_1.png',
    'assets/splash/splash_2.png',
    'assets/splash/splash_3.png',
    'assets/splash/splash_4.png',
    'assets/splash/splash_5.png',
    'assets/splash/splash_6.png',
    'assets/splash/splash_7.png',
  ];

  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    for (int i = 0; i < _splashImages.length; i++) {
      await Future.delayed(const Duration(milliseconds: 200)); // Durasi setiap frame
      if (mounted) {
        setState(() {
          _currentImageIndex = i;
        });
      }
    }
    // Setelah animasi selesai, navigasi ke halaman selanjutnya
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    if (mounted) {
      // Mengarahkan ke OnboardingOrAuthWrapper yang telah kita buat di main.dart
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingOrAuthWrapper()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih sesuai UI
      body: Center(
        child: Image.asset(
          _splashImages[_currentImageIndex],
          width: 150, // Sesuaikan ukuran gambar sesuai keinginan
          height: 150,
        ),
      ),
    );
  }
}