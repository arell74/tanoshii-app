// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tanoshii_app/screens/siswa/chat_bot/chat_bot_screen.dart';
import '../flashcard/flashcard_screen.dart';
import '../profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Fungsi untuk mengambil nama dari Firestore
  Future<String> _getUserName() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        if (doc.exists && doc.data() != null) {
          return doc.get('name') ?? 'Pelajar';
        }
      }
    } catch (e) {
      print("Error mengambil nama: $e");
    }
    return 'Siswa';
  }

  // Logika sederhana: Memilih kanji berdasarkan sisa pembagian tanggal
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
      body: Column(
        children: [
          // ── HEADER SECTION ──
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
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
                        // ── KODE BARU: NAMA DINAMIS ──
                        FutureBuilder<String>(
                          future: _getUserName(),
                          builder: (context, snapshot) {
                            String displayName =
                                'Memuat...'; // Teks sementara saat loading

                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // Ambil datanya
                              String fullName = snapshot.data ?? 'Siswa';

                              // Opsional: Ambil kata pertama saja agar tidak kepanjangan di layar
                              displayName = fullName.split(' ')[0];
                            }

                            return Text(
                              'Halo, $displayName 👋',
                              style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    // const CircleAvatar(
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/boruto.jpeg',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Streak Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
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
                  valueColor: const AlwaysStoppedAnimation<Color>(gold),
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ),

          // ── BODY SECTION (SCROLLABLE) ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // KARTU LANJUTKAN
                _buildSectionLabel('Lanjutkan'),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => FlashcardScreen(module: 'Hiragana')));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3D5A8A),
                          Color(0xFF2A4A6E),
                        ], // Indigo
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
                            'あ',
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
                              'Hiragana Baris き・さ',
                              style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            LinearProgressIndicator(
                              value: 0.4,
                              backgroundColor: Colors.white.withOpacity(0.15),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFE8CC7E),
                              ), // gold light
                              minHeight: 4,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '▶ LANJUTKAN → 12/46',
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
                ),
                const SizedBox(height: 24),

                // 2. MODUL BELAJAR GRID
                _buildSectionLabel('Modul Belajar'),
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
                                  FlashcardScreen(moduleTitle: 'Hiragana'),
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
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FlashcardScreen(moduleTitle: 'Katakana'),
                            ),
                          );
                        },
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
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FlashcardScreen(moduleTitle: 'Kanji_N5'),
                            ),
                          );
                        },
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
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatBotScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 3. KARAKTER HARI INI
                _buildSectionLabel('Karakter Hari Ini'),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFDF8EE),
                        Color(0xFFF5EAD6),
                      ], // Cream gradient
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
                          kanjiData['char']!, // Menampilkan karakter dinamis
                          style: GoogleFonts.notoSerifJp(
                            color: gold,
                            fontSize: 28,
                          ),
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
                              'Stroke: 11 · Jōyō Kanji',
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
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
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
}
