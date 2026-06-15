import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── FUNGSI BARU: Mengembalikan Map berisi Role & Base Domain ──
  Future<Map<String, String>> _detectRoleFromEmail(String email) async {
    final parts = email.split('@');
    if (parts.length != 2) return {'role': 'Pelajar', 'domain': ''};

    final fullDomain = parts[1];

    try {
      final snapshot = await _db.collection('akademi_domains').get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final baseDomain = data['domain'] as String? ?? '';
        final senseiPrefix = data['sensei_prefix'] as String? ?? 'sensei';
        final siswaPrefix = data['siswa_prefix'] as String? ?? 'siswa';

        // Jika cocok dengan Sensei
        if (fullDomain == '$senseiPrefix.$baseDomain') {
          return {'role': 'Sensei', 'domain': baseDomain};
        }
        // Jika cocok dengan Siswa Akademi
        if (fullDomain == '$siswaPrefix.$baseDomain') {
          return {'role': 'Pelajar Akademi', 'domain': baseDomain};
        }
      }
    } catch (e) {
      debugPrint('Error detecting role: $e');
    }

    return {'role': 'Pelajar', 'domain': ''}; 
  }

 // ── FUNGSI REGISTER (Diperbarui tanpa parameter role manual) ──
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // 2. Tangkap Role dan Domain Dasar secara bersamaan
        final roleData = await _detectRoleFromEmail(email.trim());
        final actualRole = roleData['role']!;
        final actualDomain = roleData['domain']!;

        // 3. Buat dokumen user di database
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name.trim(),
          'email': email.trim(),
          'role': actualRole,
          'akademiDomain': actualDomain,
          'photoUrl': '',
          'accuracy': 0,
          'xp': 0,
          'streak': 0,
          'createdAt': FieldValue.serverTimestamp(),
        });

        try {
          final fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            await _db.collection('users').doc(user.uid).update({
              'fcmToken': fcmToken,
            });
          }
        } catch (e) {
          debugPrint('Gagal simpan FCM token saat register: $e');
        }
        // ──────────────────────────────────────
      }
    } catch (e) {
      throw Exception('Gagal mendaftar: $e');
    }
  }

  // Fungsi Login
  Future<User?> loginUser(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email.trim(), // Tambahkan trim() agar lebih aman dari spasi nyasar
      password: password,
    );
    
    User? user = result.user;

    if (user != null) {
      try {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await _db.collection('users').doc(user.uid).update({
            'fcmToken': fcmToken,
          });
        }
      } catch (e) {
        debugPrint('Gagal perbarui FCM token saat login: $e');
      }
    }
    
    return user;
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
    return 'Pelajar';
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
