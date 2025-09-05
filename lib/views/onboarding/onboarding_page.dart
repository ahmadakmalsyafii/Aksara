// lib/views/onboarding/onboarding_page.dart
import 'package:aksara/views/onboarding/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:aksara/widgets/onboarding_content.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onboarding_1.png",
      "title": "Baca Lebih Mudah, Dimana Saja",
      "description":
      "Aksara punya ribuan e-book seru dan bermanfaat. Belajar atau baca santai jadi makin gampang!",
    },
    {
      "image": "assets/images/onboarding_2.png",
      "title": "Streak On, Semangat Belajar",
      "description":
      "Kumpulkan streak harianmu. Semakin rajin kamu membaca, semakin panjang streak dan makin seru belajarnya.",
    },
    {
      "image": "assets/images/onboarding_3.png",
      "title": "Rekomendasi Spesial Buat Kamu",
      "description":
      "Setiap bacaanmu akan membuka pintu ke buku-buku baru yang sesuai minatmu. Belajar jadi lebih dekat dengan hobimu.",
    },
  ];

  // Fungsi untuk menandai onboarding selesai dan navigasi
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              _currentPage < onboardingData.length - 1
                  ? Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed:
                  _completeOnboarding, // Panggil fungsi ini saat lewati
                  child: const Text("Lewati"),
                ),
              )
                  : const SizedBox(height: 48), // Spacer

              // Konten PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  itemBuilder: (context, index) => OnboardingContent(
                    image: onboardingData[index]['image']!,
                    title: onboardingData[index]['title']!,
                    description: onboardingData[index]['description']!,
                  ),
                ),
              ),

              // Indikator Halaman
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                      (index) => buildDot(index, context),
                ),
              ),
              const SizedBox(height: 40),

              // Tombol Lanjut/Mulai
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {
                  if (_currentPage == onboardingData.length - 1) {
                    _completeOnboarding(); // Panggil fungsi ini saat mulai
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },
                child: Text(
                  _currentPage == onboardingData.length - 1 ? "Mulai" : "Lanjut",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk indikator titik
  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Theme.of(context).primaryColor
            : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}