import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// PASTIKAN PATH IMPORT INI BENAR SESUAI STRUKTUR FOLDERMU
import '../../auth/login_screen.dart';
import 'edit_profile_screen.dart';

// 1. KITA UBAH MENJADI STATEFUL WIDGET
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Map<String, String>> _getUserProfile() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (doc.exists && doc.data() != null) {
          return {
            'name': doc.get('name') ?? 'Pengguna',
            'email': currentUser.email ?? 'Tidak ada email',
            'role': doc.get('role') ?? 'siswa',
            'photoUrl':
                (doc.data() as Map<String, dynamic>).containsKey('photoUrl')
                ? doc.get('photoUrl')
                : '',
          };
        }
      }
    } catch (e) {
      print("Error mengambil profil: $e");
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
        // 2. FUTURE BUILDER SEKARANG MEMBUNGKUS SELURUH ISI LAYAR
        child: FutureBuilder<Map<String, String>>(
          future: _getUserProfile(),
          builder: (context, snapshot) {
            // 1. Cek apakah masih loading?
            final bool isLoading =
                snapshot.connectionState != ConnectionState.done;

            String displayName = 'Memuat...';
            String displayEmail = 'Memuat email...';
            String role = 'siswa';
            String photoUrl = '';

            if (!isLoading) {
              displayName = snapshot.data?['name'] ?? 'Pengguna';
              displayEmail = snapshot.data?['email'] ?? 'Tidak ada email';
              role = snapshot.data?['role'] ?? 'siswa';
              photoUrl = snapshot.data?['photoUrl'] ?? '';
            }

            final bool isTeacher = role.toLowerCase() == 'guru';
            final Color badgeColor = isTeacher ? indigo : gold;
            final String roleLabel = isTeacher
                ? 'Sensei 先生'
                : 'Pelajar · Level 99';

            final String finalAvatarUrl = photoUrl.isNotEmpty
                ? photoUrl
                : 'https://ui-avatars.com/api/?name=${displayName.replaceAll(' ', '+')}&background=${badgeColor.value.toRadixString(16).substring(2)}&color=fff';

            return Column(
              children: [
                // ── HEADER PROFIL ──
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      // 2. GANTI BAGIAN CONTAINER FOTO INI
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: badgeColor.withOpacity(0.5),
                            width: 2,
                          ),
                          color: Colors.grey[200], // Warna dasar saat loading
                        ),
                        // Jika masih loading, tampilkan animasi muter. Jika selesai, tampilkan gambarnya!
                        child: isLoading
                            ? const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : ClipOval(
                                child: Image.network(
                                  finalAvatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.person,
                                        color: ink.withOpacity(0.5),
                                        size: 32,
                                      ),
                                ),
                              ),
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: badgeColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                roleLabel,
                                style: GoogleFonts.spaceMono(
                                  fontSize: 10,
                                  color: badgeColor,
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
                      // Error merahnya sudah hilang! Karena sekarang dia kenal variabelnya
                      _buildListTile(
                        Icons.person_outline,
                        'Edit Profil',
                        ink,
                        onTap: () async {
                          // Navigasi ke EditProfileScreen sambil melempar parameter data saat ini
                          final bool? isUpdated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                currentName:
                                    displayName, // Melempar nama user saat ini
                                currentEmail:
                                    displayEmail, // Melempar email user saat ini
                                currentPhotoUrl:
                                    finalAvatarUrl, // Melempar URL foto (ImgBB/Inisial)
                                themeColor:
                                    badgeColor, // Melempar warna tema (Emas/Biru)
                              ),
                            ),
                          );

                          // Jika kembali membawa nilai true (berhasil simpan), refresh layar profil!
                          if (isUpdated == true) {
                            setState(() {});
                          }
                        },
                      ),
                      _buildListTile(
                        Icons.lock_outline,
                        'Ubah Password',
                        ink,
                        onTap: () {},
                      ),

                      const SizedBox(height: 24),
                      _buildSectionTitle('Preferensi'),
                      _buildListTile(
                        Icons.language,
                        'Bahasa (日本語)',
                        ink,
                        onTap: () {},
                      ),
                      _buildListTile(
                        Icons.notifications_active_outlined,
                        'Posisi Notifikasi (Acak Kanan & Kiri)',
                        ink,
                        onTap: () {},
                      ),

                      const SizedBox(height: 24),
                      _buildSectionTitle('Lainnya'),
                      _buildListTile(
                        Icons.help_outline,
                        'Pusat Bantuan',
                        ink,
                        onTap: () {},
                      ),
                      _buildListTile(
                        Icons.info_outline,
                        'Tentang NihonGo!',
                        ink,
                        onTap: () {},
                      ),
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
                            title: const Text('Konfirmasi'),
                            content: const Text(
                              'Apakah yakin ingin keluar dari akun ini?',
                            ),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text(
                                  'Batal',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              CupertinoDialogAction(
                                isDestructiveAction: true,
                                child: const Text('Keluar'),
                                onPressed: () async {
                                  Navigator.of(context).pop();

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );

                                  await FirebaseAuth.instance.signOut();

                                  if (context.mounted)
                                    Navigator.of(context).pop();
                                  if (context.mounted) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  }
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
            );
          },
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

  // Menambahkan parameter onTap opsional di sini
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
        onTap: onTap, // Dipanggil di sini
      ),
    );
  }
}
