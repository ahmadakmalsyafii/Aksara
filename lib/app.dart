// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'core/routes/app_router.dart';
// import 'themes/app_theme.dart';
// import 'services/auth_service.dart';
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Aksara',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.light,
//       onGenerateRoute: AppRouter.onGenerateRoute,
//       home: const _Bootstrapper(),
//     );
//   }
// }
//
//
// class _Bootstrapper extends StatefulWidget {
//   const _Bootstrapper();
//
//
//   @override
//   State<_Bootstrapper> createState() => _BootstrapperState();
// }
//
//
// class _BootstrapperState extends State<_Bootstrapper> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await context.read<AuthService>().signInAnonymouslyIfNeeded();
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthService>();
//     if (auth.isBusy) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
//     return const SizedBox.shrink(); // router menentukan home
//   }
// }