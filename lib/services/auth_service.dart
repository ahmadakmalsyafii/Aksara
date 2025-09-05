import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Simpan data user ke Firestore
  Future<void> saveUserData(UserModel user) async {
    await _db.collection("users").doc(user.uid).set(user.toMap());
  }

  // Register dengan email & password
  Future<User?> registerWithEmail(String username, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          username: username,
          email: email,
        );
        await saveUserData(newUser);
      }

      return user;
    } catch (e) {
      print("Register error: $e");
      return null;
    }
  }

  Future<bool> checkIfEmailInUse(String email) async {
    try {
      final snapshot = await _db
          .collection("users")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } on FirebaseAuthException catch (e) {
      // Menangani error lain jika perlu
      print(e);
      return false;
    }
  }


  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      final snapshot = await _db
          .collection("users")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        String userId = snapshot.docs.first.id;
        print(
            "Di aplikasi production, panggil Cloud Function untuk mereset password user $userId");
        // Simulasi berhasil
        return true;
      }
      return false;
    } catch (e) {
      print("Error resetting password: $e");
      return false;
    }
  }

  // Login dengan email & password
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  // Login dengan Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot snapshot =
        await _db.collection("users").doc(user.uid).get();
        if (!snapshot.exists) {
          UserModel newUser = UserModel(
            uid: user.uid,
            username: user.displayName ?? "User",
            email: user.email ?? "",
          );
          await saveUserData(newUser);
        }
      }

      return user;
    } catch (e) {
      print("Google Sign-In error: $e");
      return null;
    }
  }

  Future<bool> changePassword(
      {required String currentPassword, required String newPassword}) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) return false;

      // Re-autentikasi pengguna
      AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, password: currentPassword);
      await user.reauthenticateWithCredential(credential);

      // Jika berhasil, ubah kata sandi
      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      print("Change password error: $e");
      return false;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
