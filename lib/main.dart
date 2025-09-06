// lib/main.dart
import 'package:aksara/firebase_options.dart';
import 'package:aksara/models/user_model.dart';
import 'package:aksara/services/user_service.dart';
import 'package:aksara/views/auth/choose_class_page.dart';
import 'package:aksara/views/auth/login_page.dart';
import 'package:aksara/views/main_page.dart';
import 'package:aksara/views/onboarding/onboarding_page.dart';
import 'package:aksara/views/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aksara/themes/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aksara',
      theme: AppTheme.themeData,
      home: const SplashScreen(),
    );
  }
}

class OnboardingOrAuthWrapper extends StatefulWidget {
  const OnboardingOrAuthWrapper({super.key});

  @override
  State<OnboardingOrAuthWrapper> createState() =>
      _OnboardingOrAuthWrapperState();
}

class _OnboardingOrAuthWrapperState extends State<OnboardingOrAuthWrapper> {
  late Future<bool> _checkOnboardingStatus;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus = _isOnboardingCompleted();
  }

  Future<bool> _isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkOnboardingStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          final bool onboardingCompleted = snapshot.data ?? false;
          if (onboardingCompleted) {
            return const AuthWrapper();
          } else {
            return const OnboardingPage();
          }
        }
      },
    );
  }
}

// PERBARUI AuthWrapper
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // Pengguna sudah login, cek apakah sudah memilih kelas
            return const CheckClassStatusPage();
          }
          return const LoginPage();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

// Widget BARU untuk memeriksa status kelas pengguna
class CheckClassStatusPage extends StatelessWidget {
  const CheckClassStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();

    return FutureBuilder<UserModel?>(
      future: userService.getCurrentUser(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (userSnapshot.hasData && userSnapshot.data != null) {
          final user = userSnapshot.data!;
          // Jika field 'kelas' null atau kosong, tampilkan halaman pilih kelas
          if (user.kelas == null || user.kelas!.isEmpty) {
            return const ChooseClassPage();
          }
        }
        // Jika sudah memilih kelas, arahkan ke halaman utama
        return const MainPage();
      },
    );
  }
}