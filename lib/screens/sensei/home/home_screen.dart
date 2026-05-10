import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SenseiHomeScreen extends StatelessWidget {
  const SenseiHomeScreen({Key? key}) : super(key: key);

  // FUNGSI BARU: Mengambil Nama DAN Foto sekaligus
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
            'name': doc.get('name') ?? 'Pengajar',
            'photoUrl':
                (doc.data() as Map<String, dynamic>).containsKey('photoUrl')
                ? doc.get('photoUrl')
                : '',
          };
        }
      }
    } catch (e) {
      debugPrint("Error mengambil data: $e");
    }
    return {'name': 'Pengajar', 'photoUrl': ''};
  }

  @override
  Widget build(BuildContext context) {
    const Color indigo = Color(0xFF3D5A8A);
    const Color vermillion = Color(0xFFD94F3D);
    const Color sage = Color(0xFF4A7C6F);
    const Color purple = Color(0xFF7C4F8A);
    const Color bgColor = Color(0xFFF5F4F0);

    return Scaffold(
      backgroundColor: bgColor,
      body: FutureBuilder<Map<String, String>>(
        future: _getUserData(), // Memanggil fungsi gabungan
        builder: (context, snapshot) {
          String displayName = 'Memuat...';
          String photoUrl = '';
          bool isLoading = snapshot.connectionState != ConnectionState.done;

          if (!isLoading) {
            displayName = snapshot.data?['name'] ?? 'Pengajar';
            photoUrl = snapshot.data?['photoUrl'] ?? '';
          }

          // Fallback UI-Avatar jika user belum punya foto
          final String finalAvatarUrl = photoUrl.isNotEmpty
              ? photoUrl
              : 'https://ui-avatars.com/api/?name=${displayName.replaceAll(' ', '+')}&background=3D5A8A&color=fff';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── HEADER BIRU (INDIGO) ──
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                  decoration: const BoxDecoration(
                    color: indigo,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
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
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                'Halo, $displayName-sensei',
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
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),

                              // ── FOTO PROFIL DINAMIS SENSEI ──
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 2,
                                  ),
                                  color: indigo, // Warna dasar saat loading
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/zaniii.jpeg', // Gambar default Sensei
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Statistik Ringkas (3 Kolom)
                      Row(
                        children: [
                          _buildHeaderStat('32', 'SISWA'),
                          const SizedBox(width: 10),
                          _buildHeaderStat('28', 'AKTIF HARI INI'),
                          const SizedBox(width: 10),
                          _buildHeaderStat('2', 'KUIS AKTIF'),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── ALERT BANNER ──
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: vermillion.withOpacity(0.1),
                          border: Border.all(
                            color: vermillion.withOpacity(0.25),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Text('⚠️', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '2 Siswa Butuh Perhatian',
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.bold,
                                      color: vermillion,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Akurasi di bawah 50% minggu ini.',
                                    style: GoogleFonts.dmSans(
                                      color: vermillion.withOpacity(0.8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: vermillion.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── AKSI CEPAT (GRID 2x2) ──
                      Text(
                        'AKSI CEPAT',
                        style: GoogleFonts.spaceMono(
                          fontSize: 10,
                          letterSpacing: 2,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        padding: EdgeInsets
                            .zero, // Menghilangkan padding bawaan grid
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _buildActionCard(
                            'Pantau Kelas',
                            Icons.analytics_rounded,
                            indigo,
                          ),
                          _buildActionCard(
                            'Buat Kuis',
                            Icons.edit_document,
                            vermillion,
                          ),
                          _buildActionCard(
                            'Pengumuman',
                            Icons.campaign_rounded,
                            purple,
                          ),
                          _buildActionCard(
                            'Leaderboard',
                            Icons.emoji_events_rounded,
                            sage,
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // ── AKTIVITAS TERBARU ──
                      Text(
                        'AKTIVITAS TERBARU',
                        style: GoogleFonts.spaceMono(
                          fontSize: 10,
                          letterSpacing: 2,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildActivityTile(
                        'Farel menyelesaikan Kuis Hiragana Dasar',
                        'Baru saja',
                        indigo,
                      ),
                      _buildActivityTile(
                        'Zani mencapai Streak 7 Hari 🔥',
                        '15 mnt lalu',
                        sage,
                      ),
                      _buildActivityTile(
                        'Raiden Eii mendapat nilai 40% di Kuis Kanji N5',
                        '1 jam lalu',
                        vermillion,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper Widget: Header Stat Box
  Widget _buildHeaderStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.spaceMono(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.spaceMono(
                color: Colors.white70,
                fontSize: 8,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Action Card 2x2
  Widget _buildActionCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {}, // TODO: Hubungkan ke tab navigasi yang sesuai
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget: Activity Tile
  Widget _buildActivityTile(String title, String time, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history_rounded, color: iconColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: const Color(0xFF1A1A2E),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: GoogleFonts.spaceMono(fontSize: 10, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
