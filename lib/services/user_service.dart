import 'package:aksara/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!);
  }

  Stream<UserModel?> getCurrentUserStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _db
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromMap(doc.data()!) : null);
  }

  Future<void> updateUserData(UserModel user) async {
    await _db.collection("users").doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  Future<void> addPoints(int points) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userRef = _db.collection('users').doc(uid);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      if (!snapshot.exists) {
        transaction.set(userRef, {
          'points': points,
          'email': _auth.currentUser?.email,
        });
      } else {
        final currentPoints = snapshot['points'] ?? 0;
        transaction.update(userRef, {
          'points': currentPoints + points,
        });
      }
    });
  }

  Stream<int> getUserPoints() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _db.collection('users').doc(uid).snapshots().map((snap) {
      if (!snap.exists) return 0;
      return (snap['points'] ?? 0) as int;
    });
  }

  Future<void> deductPoints(int points) async {
    if (uid == null) return;
    final userRef = _db.collection('users').doc(uid);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      if (snapshot.exists) {
        final currentPoints = (snapshot.data() as Map<String,
            dynamic>?)?['points'] ??
            0;
        transaction.update(userRef, {
          'points': currentPoints - points,
        });
      }
    });
  }
}
