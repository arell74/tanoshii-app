import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SenseiHomeScreen extends StatelessWidget {
  const SenseiHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);
    const Color sage = Color(0xFF4A7C6F);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: Column(
        children: [
          // ── HEADER SENSEI ──
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2A1A3E), Color(0xFF1A1A2E)],
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
                        Text('Konnichiwa, Sensei! 👨‍🏫', 
                          style: GoogleFonts.dmSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('MANAJEMEN KELAS — NIHONGO!', 
                          style: GoogleFonts.spaceMono(color: Colors.white54, fontSize: 10, letterSpacing: 1)),
                      ],
                    ),
                    const CircleAvatar(backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=Sensei+Farel&background=c9a84c&color=fff')),
                  ],
                ),
                const SizedBox(height: 24),
                // Ringkasan Kelas Row
                Row(
                  children: [
                    _buildQuickStat('32', 'Total Murid', Colors.white),
                    _buildDivider(),
                    _buildQuickStat('86%', 'Akurasi Kelas', gold),
                    _buildDivider(),
                    _buildQuickStat('12', 'Butuh Bantuan', vermillion),
                  ],
                ),
              ],
            ),
          ),

          // ── DAFTAR MURID ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSectionHeader('Pemantauan Aktif', 'Real-time'),
                _buildStudentTile('Andi Pratama', 'Level 3', '84%', '🔥 7 Hari', sage),
                _buildStudentTile('Siti Aminah', 'Level 2', '92%', '🔥 14 Hari', gold),
                _buildStudentTile('Budi Santoso', 'Level 1', '45%', '❄️ 2 Hari', vermillion),
                _buildStudentTile('Dewi Lestari', 'Level 3', '88%', '🔥 5 Hari', sage),
                
                const SizedBox(height: 24),
                _buildSectionHeader('Konten Populer', 'Statistik Materi'),
                _buildContentCard('Hiragana Baris あ', 'Paling banyak dipelajari', gold),
                _buildContentCard('Kanji N5: Kata Kerja', 'Tingkat kesulitan tinggi', vermillion),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: GoogleFonts.spaceMono(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: GoogleFonts.dmSans(color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildDivider() => Container(height: 20, width: 1, color: Colors.white10);

  Widget _buildSectionHeader(String title, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E))),
          Text(sub, style: GoogleFonts.spaceMono(fontSize: 10, color: Colors.black26)),
        ],
      ),
    );
  }

  Widget _buildStudentTile(String name, String level, String acc, String streak, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(width: 4, height: 30, decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(level, style: GoogleFonts.spaceMono(fontSize: 10, color: Colors.black45)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(acc, style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold, color: statusColor)),
              Text(streak, style: GoogleFonts.dmSans(fontSize: 10, color: Colors.black38)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_stories, color: color, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E))),
              Text(desc, style: GoogleFonts.dmSans(fontSize: 11, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}