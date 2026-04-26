import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fungsi Register
  Future<User?> registerUser(
    String email,
    String password,
    String role,
    String name,
  ) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = result.user;

    if (user != null) {
      // Simpan role dan data profil ke Firestore
      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return user;
  }

  // Fungsi Login
  Future<User?> loginUser(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  // Ambil Data Role Pengguna
  Future<String> getUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return doc.get('role') ?? 'Pelajar';
      }
    } catch (e) {
      print("Error fetching role: $e");
    }
    return 'Pelajar'; // Nilai default yang aman
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
