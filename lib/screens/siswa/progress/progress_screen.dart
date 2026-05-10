import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // Fungsi untuk mengambil Data User (Nama & Foto) dari Firebase
  Future<Map<String, String>> _getUserData() async {
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
            'photoUrl':
                (doc.data() as Map<String, dynamic>).containsKey('photoUrl')
                ? doc.get('photoUrl')
                : '',
          };
        }
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
    return {'name': 'Pengguna', 'photoUrl': ''};
  }

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color paper = Color(0xFFFAF7F2);
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);
    const Color sage = Color(0xFF4A7C6F);

    // Variabel Dummy (Nanti ini yang akan kita ubah jadi dinamis dari Firestore)
    final String currentMonth = 'APRIL 2026';
    final int userStreak = 7;
    final int userXP = 640;
    final String userAccuracy = '84%';

    final double hiraganaMastery = 0.26;
    final double katakanaMastery = 0.10;
    final double kanjiMastery = 0.05;

    return Scaffold(
      backgroundColor: paper,
      body: FutureBuilder<Map<String, String>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          // Mengatur tampilan saat data dimuat
          String displayName = 'Memuat...';
          String photoUrl = '';
          bool isLoading = snapshot.connectionState != ConnectionState.done;

          if (!isLoading) {
            displayName = snapshot.data?['name'] ?? 'Pengguna';
            photoUrl = snapshot.data?['photoUrl'] ?? '';
          }

          final String finalAvatarUrl = photoUrl.isNotEmpty
              ? photoUrl
              : 'https://ui-avatars.com/api/?name=${displayName.replaceAll(' ', '+')}&background=${gold.value.toRadixString(16).substring(2)}&color=fff';

          return Column(
            children: [
              // ── HEADER SECTION ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 50, 18, 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ink, Color(0xFF2D1A3E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progres Belajar',
                      style: GoogleFonts.notoSerifJp(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '学習の進捗 · $currentMonth',
                      style: GoogleFonts.spaceMono(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // ── BODY SECTION ──
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Foto Profil Dinamis
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: gold.withOpacity(0.5),
                            width: 2,
                          ),
                          color: Colors.grey[200],
                        ),
                        child: isLoading
                            ? const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : ClipOval(
                                child: Image.network(
                                  finalAvatarUrl,
                                  fit: BoxFit.cover,
                                  // JIKA GAGAL LOAD DARI INTERNET, PAKAI FOTO BORUTO!
                                  errorBuilder: (context, error, stackTrace) {
                                    // Ini akan nge-print alasan pastinya ke Debug Console!
                                    debugPrint("ALASAN GAMBAR GAGAL: $error");
                                    return Image.asset(
                                      'assets/images/boruto.jpeg',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Nama Dinamis
                    Center(
                      child: Text(
                        displayName,
                        style: GoogleFonts.dmSans(
                          color: ink,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 1. STATS ROW
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            userStreak.toString(),
                            'Streak',
                            vermillion,
                            ink,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatCard(
                            userXP.toString(),
                            'XP Total',
                            gold,
                            ink,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatCard(
                            userAccuracy,
                            'Akurasi',
                            sage,
                            ink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 2. MASTERY CARD
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: ink.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PENGUASAAN AKSARA',
                            style: GoogleFonts.spaceMono(
                              fontSize: 10,
                              color: ink.withOpacity(0.4),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildMasteryItem(
                            'Hiragana',
                            hiraganaMastery,
                            vermillion,
                            ink,
                          ),
                          const SizedBox(height: 12),
                          _buildMasteryItem(
                            'Katakana',
                            katakanaMastery,
                            const Color(0xFF3D5A8A),
                            ink,
                          ),
                          const SizedBox(height: 12),
                          _buildMasteryItem(
                            'Kanji N5',
                            kanjiMastery,
                            sage,
                            ink,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. HEATMAP CARD
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: ink.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AKTIVITAS 4 MINGGU TERAKHIR',
                            style: GoogleFonts.spaceMono(
                              fontSize: 10,
                              color: ink.withOpacity(0.4),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                ),
                            itemCount: 28,
                            itemBuilder: (context, index) {
                              int intensity = (index * 7) % 5;
                              return Container(
                                decoration: BoxDecoration(
                                  color: _getHeatmapColor(
                                    intensity,
                                    vermillion,
                                    ink,
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper: Stat Card (Ditambahkan parameter ink color agar konsisten)
  Widget _buildStatCard(String value, String label, Color color, Color ink) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ink.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.spaceMono(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.spaceMono(
              fontSize: 8,
              color: ink.withOpacity(0.4),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Mastery Bar
  Widget _buildMasteryItem(
    String name,
    double percent,
    Color color,
    Color ink,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: ink,
              ),
            ),
            Text(
              '${(percent * 100).toInt()}%',
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percent,
          backgroundColor: ink.withOpacity(0.06),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  // Helper: Heatmap Color Logic
  Color _getHeatmapColor(int intensity, Color baseColor, Color ink) {
    if (intensity == 0) return ink.withOpacity(0.05);
    return baseColor.withOpacity(0.2 * intensity);
  }
}
