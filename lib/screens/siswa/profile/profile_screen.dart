import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/login_screen.dart';
import 'about_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'help_center_screen.dart';
import 'languange_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Simpan Future di variable agar tidak dipanggil ulang setiap rebuild
  late Future<Map<String, String>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _getUserProfile();
  }

  // Fungsi untuk refresh data
  void _refreshData() {
    setState(() {
      _profileFuture = _getUserProfile();
    });
  }

  Future<Map<String, String>> _getUserProfile() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (doc.exists && doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'name': data['name'] ?? 'Pengguna',
            'email': currentUser.email ?? 'Tidak ada email',
            'role': data['role'] ?? 'siswa',
            'photoUrl': data['photoUrl'] ?? '',
          };
        }
      }
    } catch (e) {
      debugPrint("Error mengambil profil: $e");
    }
    return {
      'name': 'Pengguna',
      'email': 'Error',
      'role': 'siswa',
      'photoUrl': '',
    };
  }

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color paper = Color(0xFFFAF7F2);
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);
    const Color indigo = Color(0xFF3D5A8A);

    return Scaffold(
      backgroundColor: paper,
      body: SafeArea(
        child: FutureBuilder<Map<String, String>>(
          future:
              _profileFuture,
          builder: (context, snapshot) {
            final bool isLoading =
                snapshot.connectionState == ConnectionState.waiting;

            final String displayName = snapshot.data?['name'] ?? 'Memuat...';
            final String displayEmail =
                snapshot.data?['email'] ?? 'Memuat email...';
            final String role = snapshot.data?['role'] ?? 'siswa';
            final String photoUrl = snapshot.data?['photoUrl'] ?? '';

            final bool isTeacher = role.toLowerCase() == 'guru';
            final Color badgeColor = isTeacher ? indigo : gold;
            final String roleLabel = isTeacher
                ? 'Sensei 先生'
                : 'Pelajar · Level 99';

            final String finalAvatarUrl = photoUrl.isNotEmpty
                ? photoUrl
                : 'https://ui-avatars.com/api/?name=${displayName.replaceAll(' ', '+')}&background=${gold.value.toRadixString(16).substring(2)}&color=fff';

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      _buildAvatar(
                        isLoading,
                        finalAvatarUrl,
                        badgeColor,
                        ink,
                        finalAvatarUrl,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: GoogleFonts.dmSans(
                                color: ink,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              displayEmail,
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: ink.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            _buildRoleBadge(roleLabel, badgeColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildSectionTitle('Akun'),
                      _buildListTile(
                        Icons.person_outline,
                        'Edit Profil',
                        ink,
                        onTap: () async {
                          final bool? isUpdated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                currentName: displayName,
                                currentEmail: displayEmail,
                                currentPhotoUrl: finalAvatarUrl,
                                themeColor: badgeColor,
                              ),
                            ),
                          );
                          if (isUpdated == true) _refreshData();
                        },
                      ),
                      _buildListTile(
                        Icons.lock_outline,
                        'Ubah Password',
                        ink,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Preferensi'),
                      _buildListTile(
                        Icons.language,
                        'Bahasa (日本語)',
                        ink,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LanguageScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Lainnya'),
                      _buildListTile(
                        Icons.help_outline,
                        'Pusat Bantuan',
                        ink,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpCenterScreen(),
                          ),
                        ),
                      ),
                      _buildListTile(
                        Icons.info_outline,
                        'Tentang NihonGo!',
                        ink,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── TOMBOL LOGOUT ──
                _buildLogoutButton(context, vermillion),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatar(
    bool isLoading,
    String url,
    Color badgeColor,
    Color ink,
    String finalAvatarUrl,
  ) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: badgeColor.withOpacity(0.5), width: 2),
        color: Colors.grey[200],
      ),
      child: isLoading
          ? const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : ClipOval(
              child: Image.network(
                finalAvatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint("ALASAN GAMBAR GAGAL: $error");
                  return Image.asset(
                    'assets/images/boruto.jpeg',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
    );
  }

  Widget _buildRoleBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, Color color) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _showLogoutDialog(context),
          icon: Icon(Icons.logout, color: color),
          label: Text(
            'Keluar Akun',
            style: GoogleFonts.dmSans(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(color: color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah yakin ingin keluar dari akun ini?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Keluar'),
            onPressed: () async {
              Navigator.pop(context); // Tutup dialog
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
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

  Widget _buildListTile(
    IconData icon,
    String title,
    Color ink, {
    VoidCallback? onTap,
  }) {
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
        onTap: onTap,
      ),
    );
  }
}
