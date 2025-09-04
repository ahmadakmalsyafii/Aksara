// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/auth_service.dart';
// import '../services/progress_repository.dart';
//
//
// class ResultArgs {
//   final String bookId;
//   final String chapterId;
//   final int total;
//   final int correct;
//   ResultArgs({required this.bookId, required this.chapterId, required this.total, required this.correct});
// }
//
//
// class ResultView extends StatefulWidget {
//   static const route = '/result';
//   final String bookId;
//   final String chapterId;
//   final int total;
//   final int correct;
//   const ResultView({super.key, required this.bookId, required this.chapterId, required this.total, required this.correct});
//   factory ResultView.fromArgs(Object? args) {
//     final a = args as ResultArgs;
//     return ResultView(bookId: a.bookId, chapterId: a.chapterId, total: a.total, correct: a.correct);
//   }
//
//
//   @override
//   State<ResultView> createState() => _ResultViewState();
// }
//
//
//
// class _ResultViewState extends State<ResultView> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final uid = context.read<AuthService>().user!.uid;
//       await context.read<ProgressRepository>().saveScore(
//         uid: uid,
//         bookId: widget.bookId,
//         chapterId: widget.chapterId,
//         total: widget.total,
//         correct: widget.correct,
//       );
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     const String guestId = "guest_user";
//     final pass = widget.correct >= (widget.total * 0.6).round();
//     return Scaffold(
//       appBar: AppBar(title: const Text('Hasil Kuis')),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(pass ? Icons.emoji_events_outlined : Icons.refresh_outlined, size: 64),
//               const SizedBox(height: 12),
//               Text('Skor: ${widget.correct}/${widget.total}', style: Theme.of(context).textTheme.headlineSmall),
//               const SizedBox(height: 8),
//               Text(pass ? 'Lulus! Bab berikutnya terbuka.' : 'Belum lulus. Silakan ulangi.'),
//               const SizedBox(height: 24),
//               FilledButton(
//                 onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
//                 child: const Text('Kembali ke Beranda'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }