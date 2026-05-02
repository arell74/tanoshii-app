import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color paper = Color(0xFFFAF7F2);
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);

    Future<String> _getUserName() async {
      try {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          DocumentSnapshot doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();
          if (doc.exists && doc.data() != null) {
            return doc.get('name') ?? 'Pengajar';
          }
        }
      } catch (e) {
        print("Error mengambil nama: $e");
      }
      return 'Pengajar';
    }

    return Scaffold(
      backgroundColor: paper,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER PROFIL ──
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/zaniii.jpeg'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String>(
                          future: _getUserName(),
                          builder: (context, snapshot) {
                            String displayName = 'Memuat...';

                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              String fullName = snapshot.data ?? 'Pengajar';
                              displayName = fullName;
                            }

                            return Text(
                              displayName,
                              style: GoogleFonts.dmSans(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        // Text('Farel Fauzan', style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold, color: ink)),
                        Text(
                          'zani@email.com',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: ink.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: gold.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Pengajar',
                            style: GoogleFonts.spaceMono(
                              fontSize: 10,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── MENU PENGATURAN ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildSectionTitle('Akun'),
                  _buildListTile(Icons.person_outline, 'Edit Profil', ink),
                  _buildListTile(Icons.lock_outline, 'Ubah Password', ink),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Preferensi'),
                  _buildListTile(Icons.language, 'Bahasa (日本語)', ink),
                  _buildListTile(
                    Icons.notifications_active_outlined,
                    'Posisi Notifikasi (Acak Kanan & Kiri)',
                    ink,
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Lainnya'),
                  _buildListTile(Icons.help_outline, 'Pusat Bantuan', ink),
                  _buildListTile(Icons.info_outline, 'Tentang NihonGo!', ink),
                ],
              ),
            ),

            // ── TOMBOL LOGOUT ──
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: Text('Konfirmasi'),
                        content: Text('Apakah yakin ingin logout?'),
                        actions: [
                          CupertinoDialogAction(
                            child: Text(
                              'Tidak',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); // tutup dialog
                            },
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: Text('Ya'),
                            onPressed: () {
                              Navigator.of(context).pop(); // tutup dialog dulu

                              // lanjut logout
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout, color: vermillion),
                  label: Text(
                    'Keluar Akun',
                    style: GoogleFonts.dmSans(
                      color: vermillion,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: vermillion),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.spaceMono(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1A1A2E).withOpacity(0.4),
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, Color ink) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ink.withOpacity(0.05)),
      ),
      child: ListTile(
        leading: Icon(icon, color: ink.withOpacity(0.7), size: 22),
        title: Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: ink,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: ink.withOpacity(0.3),
          size: 20,
        ),
        onTap:
            () {}, // Tambahkan navigasi ke masing-masing halaman pengaturan di sini
      ),
    );
  }
}
