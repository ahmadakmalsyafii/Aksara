import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aksara/models/read_progress_model.dart';

class ProgressService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> saveProgress(String chapterId, int lastPage) async {
    final user = auth.currentUser;
    if (user == null) return;

    final ref = firestore
        .collection("users")
        .doc(user.uid)
        .collection("progress")
        .doc(chapterId);

    await ref.set({
      "chapterId": chapterId,
      "lastPage": lastPage,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<ReadingProgress?> getProgress(String chapterId) async {
    final user = auth.currentUser;
    if (user == null) return null;

    final ref = firestore
        .collection("users")
        .doc(user.uid)
        .collection("progress")
        .doc(chapterId);

    final snapshot = await ref.get();
    if (!snapshot.exists) return null;

    final data = snapshot.data()!;
    return ReadingProgress(
      chapterId: data["chapterId"],
      lastPage: data["lastPage"] ?? 0,
      updatedAt: (data["updatedAt"] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
