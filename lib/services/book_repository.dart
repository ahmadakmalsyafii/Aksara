// import '../models/book_model.dart';
//
//
// class BookRepository {
// // Untuk demo: data lokal. Produksi: ambil dari Firestore `books/{bookId}/chapters`.
//   BookModel getSampleBook() {
//     final chapters = [
//       Chapter(
//         id: '1',
//         title: 'Pengantar Sains',
//         content:
//         'Sains mempelajari fenomena alam melalui observasi dan eksperimen. Konsep dasar: hipotesis, variabel, dan metode ilmiah...',
//       ),
//       Chapter(
//         id: '2',
//         title: 'Metode Ilmiah',
//         content:
//         'Langkah-langkah metode ilmiah: mengamati, merumuskan masalah, membuat hipotesis, eksperimen, analisis, dan kesimpulan...',
//       ),
//     ];
//     return BookModel(id: 'intro-to-science', title: 'Pengantar Sains', author: 'Tim Edu', chapters: chapters);
//   }
// }