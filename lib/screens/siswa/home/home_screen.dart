// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tanoshii_app/screens/siswa/chat_bot/chat_bot_screen.dart';
import 'package:tanoshii_app/screens/siswa/flashcard/sub_modul.dart';
import '../flashcard/flashcard_screen.dart';
import '../student_profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // ── 1. FUNGSI PENGAMBIL DATA ──
  Future<Map<String, dynamic>> _getUserProfile() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (doc.exists && doc.data() != null) {
          var data = doc.data() as Map<String, dynamic>;
          return {
            'name': data['name'] ?? 'Siswa',
            'photoUrl': data.containsKey('photoUrl') ? data['photoUrl'] : '',
            // Ambil field lastActivity dari Firestore
            'lastActivity': data.containsKey('lastActivity')
                ? data['lastActivity']
                : null,
          };
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    return {'name': 'Siswa', 'photoUrl': '', 'lastActivity': null};
  }

  Map<String, String> _getKanjiOfTheDay() {
    final List<Map<String, String>> kanjiList = [
      {'char': '猫', 'romaji': 'Neko', 'meaning': 'Kucing', 'stroke': '11'},
      {'char': '犬', 'romaji': 'Inu', 'meaning': 'Anjing', 'stroke': '4'},
      {'char': '水', 'romaji': 'Mizu', 'meaning': 'Air', 'stroke': '4'},
      {'char': '火', 'romaji': 'Hi', 'meaning': 'Api', 'stroke': '4'},
      {'char': '木', 'romaji': 'Ki', 'meaning': 'Pohon', 'stroke': '4'},
    ];
    int dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    return kanjiList[dayOfYear % kanjiList.length];
  }

  // ── 2. FUNGSI BUILD UTAMA (Jauh lebih bersih!) ──
  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color inkSoft = Color(0xFF2D2D4A);
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);
    const Color paper = Color(0xFFFAF7F2);
    final kanjiData = _getKanjiOfTheDay();

    return Scaffold(
      backgroundColor: paper,
      // FUTURE BUILDER DIPINDAH KE SINI (Membungkus seluruh layar)
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserProfile(),
        builder: (context, snapshot) {
          // 1. Ambil datanya di sini
          final userData = snapshot.data;
          final lastActivity = userData?['lastActivity'];

          return Column(
            children: [
              // 2. Kirim userData ke Header
              _buildHeader(context, ink, inkSoft, gold, vermillion, userData),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildSectionLabel('Lanjutkan', ink),
                    // 3. Sekarang lastActivity berhasil dikenali!
                    _buildContinueCard(context, lastActivity),
                    const SizedBox(height: 24),

                    _buildSectionLabel('Modul Belajar', ink),
                    _buildModulesGrid(context, vermillion, gold),
                    const SizedBox(height: 24),

                    _buildSectionLabel('Karakter Hari Ini', ink),
                    _buildKanjiCard(kanjiData, ink, gold),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── 3. KUMPULAN WIDGET HELPER ──

  // Helper: Header Section
  // Tambahan parameter Map<String, dynamic>? userData di dalam kurung ini
  Widget _buildHeader(
    BuildContext context,
    Color ink,
    Color inkSoft,
    Color gold,
    Color vermillion,
    Map<String, dynamic>? userData,
  ) {
    String displayName = 'Memuat...';
    String imageUrl = '';
    String initial = '?';

    // Olah data jika sudah tidak null (loading selesai)
    if (userData != null) {
      String fullName = userData['name'] ?? 'Siswa';
      displayName = fullName.split(' ')[0];
      imageUrl = userData['photoUrl'] ?? '';
      initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [ink, inkSoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'おはようございます',
                    style: GoogleFonts.spaceMono(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    'Halo, $displayName 👋',
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildNotificationBell(vermillion),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: userData == null
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : (imageUrl.isNotEmpty)
                          ? ClipOval(
                              child: Image.network(
                                imageUrl,
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Text(
                                      initial,
                                      style: GoogleFonts.dmSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                              ),
                            )
                          : Text(
                              initial,
                              style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Streak Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: gold.withOpacity(0.12),
              border: Border.all(color: gold.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  'Streak Harian',
                  style: GoogleFonts.dmSans(
                    color: gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  '7 hari',
                  style: GoogleFonts.spaceMono(
                    color: gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // XP Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'XP 999 / 1000',
                style: GoogleFonts.spaceMono(
                  color: Colors.white54,
                  fontSize: 10,
                ),
              ),
              Text(
                'Level 3 · N5',
                style: GoogleFonts.spaceMono(
                  color: Colors.white54,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: 0.69,
            backgroundColor: Colors.white.withOpacity(0.1),
            // valueColor: const AlwaysStoppedAnimation<Color>(gold),
            valueColor: AlwaysStoppedAnimation<Color>(gold),
            minHeight: 5,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  // ── WIDGET BARU: POP-UP LIQUID GLASS NOTIFIKASI ──
  void _showGlassNotification(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color purple = Color(0xFF7C4F8A);

    showDialog(
      context: context,
      barrierColor: ink.withOpacity(0.4),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 400),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.5),
                      Colors.white.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── HEADER POP-UP ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: purple.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.campaign_rounded,
                                color: purple,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Pengumuman',
                              style: GoogleFonts.dmSans(
                                color: ink,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: ink),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.black12),
                    const SizedBox(height: 12),

                    // ── ISI PENGUMUMAN DENGAN FILTER DOMAIN ──
                    Flexible(
                      child: FutureBuilder<DocumentSnapshot>(
                        // 1. Cek dulu identitas siswa yang sedang membuka pop-up ini
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(color: purple),
                            );
                          }

                          String studentDomain = '';
                          if (userSnapshot.hasData &&
                              userSnapshot.data!.exists) {
                            var userData =
                                userSnapshot.data!.data()
                                    as Map<String, dynamic>?;

                            studentDomain = userData?['akademiDomain'] ?? '';
                          }

                          // 3. Panggil pengumuman yang HANYA berasal dari domain yang sama
                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('announcements')
                                .where(
                                  'akademiDomain',
                                  isEqualTo: studentDomain,
                                ) // 👈 FILTER KEAMANAN
                                .orderBy('timestamp', descending: true)
                                .limit(5)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(
                                    color: purple,
                                  ),
                                );
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Text(
                                  'Belum ada pengumuman.',
                                  style: GoogleFonts.dmSans(
                                    color: ink.withOpacity(0.6),
                                  ),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var data =
                                      snapshot.data!.docs[index].data()
                                          as Map<String, dynamic>;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                    child: Text(
                                      data['message'] ?? '',
                                      style: GoogleFonts.dmSans(
                                        color: ink,
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper: Kartu Lanjutkan Belajar
  Widget _buildContinueCard(
    BuildContext context,
    Map<String, dynamic>? lastActivity,
  ) {
    const Color ink = Color(0xFF1A1A2E);
    const Color vermillion = Color(0xFFD94F3D);

    // 1. JIKA BELUM ADA RIWAYAT BELAJAR (USER BARU)
    if (lastActivity == null || lastActivity.isEmpty) {
      return GestureDetector(
        onTap: () {
          // Arahkan ke SubModule Hiragana sebagai awalan default
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SubModuleScreen(category: 'Hiragana'),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: ink.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MULAI PERJALANANMU',
                style: GoogleFonts.spaceMono(
                  color: ink.withOpacity(0.5),
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Mulai Belajar Hiragana',
                style: GoogleFonts.dmSans(
                  color: ink,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ayo kuasai huruf dasar bahasa Jepang!',
                style: GoogleFonts.dmSans(
                  color: ink.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 2. JIKA SUDAH ADA RIWAYAT BELAJAR
    // Ekstrak data dari Firebase
    String category = lastActivity['category'] ?? 'Hiragana';
    String title = lastActivity['title'] ?? 'Belum ada judul';
    int progress = lastActivity['progress'] ?? 0;
    int total = lastActivity['total'] ?? 10;

    // Hitung persentase untuk progress bar (0.0 sampai 1.0)
    double progressValue = total > 0 ? (progress / total) : 0.0;

    return GestureDetector(
      onTap: () {
        // Ketika diklik, arahkan ke daftar level kategori tersebut
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubModuleScreen(category: category),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3D5A8A), Color(0xFF2A4A6E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -20,
              child: Text(
                category == 'Hiragana'
                    ? 'あ'
                    : (category == 'Katakana' ? 'ア' : '字'),
                style: GoogleFonts.notoSerifJp(
                  fontSize: 80,
                  color: Colors.white.withOpacity(0.07),
                  height: 1,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SEDANG DIPELAJARI',
                  style: GoogleFonts.spaceMono(
                    color: Colors.white60,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$category $title',
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFE8CC7E),
                  ),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
                const SizedBox(height: 8),
                Text(
                  '▶ LANJUTKAN → $progress/$total',
                  style: GoogleFonts.spaceMono(
                    color: const Color(0xFFE8CC7E),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── WIDGET BARU: LONCENG NOTIFIKASI ──
  Widget _buildNotificationBell(Color badgeColor) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('announcements')
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        bool hasNewAnnouncement = false;
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          hasNewAnnouncement = true;
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: () {
                  _showGlassNotification(context);
                },
              ),
            ),

            if (hasNewAnnouncement)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1A1A2E),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // Helper: Grid Modul Belajar
  Widget _buildModulesGrid(BuildContext context, Color vermillion, Color gold) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildModuleCard(
                'あ',
                'Hiragana',
                '46 karakter',
                const Color(0xFFFDE0DC),
                vermillion,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const SubModuleScreen(category: 'Hiragana'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildModuleCard(
                'ア',
                'Katakana',
                '46 karakter',
                const Color(0xFFDCE8FD),
                const Color(0xFF6B8EC9),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SubModuleScreen(category: 'Katakana'),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildModuleCard(
                '字',
                'Kanji N5',
                '103 karakter',
                const Color(0xFFDDF0E8),
                const Color(0xFF4A7C6F),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SubModuleScreen(category: 'Kanji_N5'),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildModuleCard(
                '🤖',
                'AI Sensei',
                'Chat & tanya',
                const Color(0xFFFAF0D0),
                gold,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatBotScreen(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper: Kartu Kanji Hari Ini
  Widget _buildKanjiCard(Map<String, String> kanjiData, Color ink, Color gold) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFDF8EE), Color(0xFFF5EAD6)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: ink,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              kanjiData['char']!,
              style: GoogleFonts.notoSerifJp(color: gold, fontSize: 28),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KANJI HARI INI',
                  style: GoogleFonts.spaceMono(
                    color: ink.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${kanjiData['char']} — ${kanjiData['romaji']} (${kanjiData['meaning']})',
                  style: GoogleFonts.dmSans(
                    color: ink,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stroke: ${kanjiData['stroke']} · Jōyō Kanji',
                  style: GoogleFonts.dmSans(
                    color: ink.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Teks Label Section
  Widget _buildSectionLabel(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.dmSans(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper: Kartu Kecil Modul
  Widget _buildModuleCard(
    String icon,
    String title,
    String subtitle,
    Color bgColor,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              icon,
              style: GoogleFonts.notoSerifJp(
                fontSize: 24,
                color: iconColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.dmSans(
                color: const Color(0xFF1A1A2E),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.spaceMono(
                color: const Color(0xFF1A1A2E).withOpacity(0.5),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function untuk membuat label section
Widget _buildSectionLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text.toUpperCase(),
      style: GoogleFonts.spaceMono(
        color: const Color(0xFF1A1A2E).withOpacity(0.4),
        fontSize: 10,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

// Helper function untuk membuat kotak Modul Belajar
Widget _buildModuleCard(
  String icon,
  String title,
  String subtitle,
  Color bgColor,
  Color dotColor,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                icon,
                style: GoogleFonts.notoSerifJp(
                  fontSize: 24,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.spaceMono(
                  fontSize: 9,
                  color: const Color(0xFF1A1A2E).withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
