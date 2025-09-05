import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aksara/models/book_model.dart';

class BookmarkService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  DocumentReference get _userDocRef => _db.collection('users').doc(uid);

  /// Menambah buku ke daftar bookmark
  Future<void> addBookmark(String bookId) async {
    if (uid == null) return;
    await _userDocRef.update({
      'bookmarks': FieldValue.arrayUnion([bookId])
    });
  }

  /// Menghapus buku dari daftar bookmark
  Future<void> removeBookmark(String bookId) async {
    if (uid == null) return;
    await _userDocRef.update({
      'bookmarks': FieldValue.arrayRemove([bookId])
    });
  }

  /// Mengecek apakah sebuah buku sudah di-bookmark
  Stream<bool> isBookmarked(String bookId) {
    if (uid == null) return Stream.value(false);
    return _userDocRef.snapshots().map((snapshot) {
      if (!snapshot.exists) return false;
      final data = snapshot.data() as Map<String, dynamic>;
      final bookmarks = List<String>.from(data['bookmarks'] ?? []);
      return bookmarks.contains(bookId);
    });
  }

  /// Mengambil semua buku yang di-bookmark oleh pengguna
  Stream<List<BookModel>> getBookmarkedBooks() {
    if (uid == null) return Stream.value([]);

    return _userDocRef.snapshots().asyncMap((userSnap) async {
      if (!userSnap.exists) return [];

      final data = userSnap.data() as Map<String, dynamic>;
      final List<String> bookIds = List<String>.from(data['bookmarks'] ?? []);

      if (bookIds.isEmpty) {
        return [];
      }

      // Ambil detail setiap buku berdasarkan ID yang ada di daftar bookmark
      final bookDocs = await _db
          .collection('books')
          .where(FieldPath.documentId, whereIn: bookIds)
          .get();

      return bookDocs.docs
          .map((doc) => BookModel.fromJson(doc.data(), doc.id))
          .toList();
    });
  }
}