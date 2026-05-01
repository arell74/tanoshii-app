import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentDetailScreen extends StatelessWidget {
  final String name;
  final int accuracy;
  final Color themeColor;
  final String initial;

  const StudentDetailScreen({
    Key? key,
    required this.name,
    required this.accuracy,
    required this.themeColor,
    required this.initial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color indigo = Color(0xFF3D5A8A);
    const Color vermillion = Color(0xFFD94F3D);
    const Color sage = Color(0xFF4A7C6F);
    const Color gold = Color(0xFFC9A84C);
    const Color bgColor = Color(0xFFF5F4F0);

    return Scaffold(
      backgroundColor: bgColor,
      // Kita gunakan AppBar standar agar otomatis ada tombol "Back" (Kembali)
      appBar: AppBar(
        backgroundColor: indigo,
        elevation: 0,
        title: Text('Detail Siswa', style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── HEADER BIRU & PROFIL ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              decoration: const BoxDecoration(
                color: indigo,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.5), width: 2)),
                    alignment: Alignment.center,
                    child: Text(initial, style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: GoogleFonts.dmSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Bergabung sejak Jan 2026', style: GoogleFonts.spaceMono(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── STATS ROW (3 KOTAK) ──
                  Row(
                    children: [
                      _buildStatBox('STREAK', '12', 'Hari', indigo),
                      const SizedBox(width: 10),
                      _buildStatBox('AKURASI', '$accuracy', '%', sage),
                      const SizedBox(width: 10),
                      _buildStatBox('LEVEL', 'N5', 'Pemula', gold),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── PENGUASAAN MODUL (MASTERY BARS) ──[cite: 1]
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withOpacity(0.15))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PENGUASAAN MODUL', style: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: const Color(0xFF1A1A2E))),
                        const SizedBox(height: 16),
                        _buildMasteryBar('Hiragana Dasar', 0.85, vermillion),
                        const SizedBox(height: 12),
                        _buildMasteryBar('Katakana', 0.40, indigo),
                        const SizedBox(height: 12),
                        _buildMasteryBar('Kanji N5', 0.15, sage),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── KARTU LEMAH (RED BOX) ──[cite: 1]
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: vermillion.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: vermillion.withOpacity(0.2))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('KARTU LEMAH — PERLU REVIEW', style: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold, color: vermillion)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildWeakCard('ね', 'ne'),
                            _buildWeakCard('を', 'wo'),
                            _buildWeakCard('ゑ', 'we'),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(color: vermillion.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: vermillion.withOpacity(0.3), style: BorderStyle.solid)),
                              child: Text('+4', style: GoogleFonts.spaceMono(color: vermillion.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── TOMBOL AKSI ──[cite: 1]
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Logika kirim pesan personal
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fitur kirim pesan ke $name belum aktif.')));
                      },
                      icon: const Icon(Icons.campaign_rounded, size: 18),
                      label: const Text('KIRIM PESAN KE SISWA INI'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: indigo,
                        side: const BorderSide(color: indigo, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        textStyle: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Stat Box
  Widget _buildStatBox(String title, String value, String unit, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.2))),
        child: Column(
          children: [
            Text(title, style: GoogleFonts.spaceMono(fontSize: 8, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value, style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                const SizedBox(width: 2),
                Text(unit, style: GoogleFonts.dmSans(fontSize: 10, color: color.withOpacity(0.7))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Mastery Bar
  Widget _buildMasteryBar(String label, double percent, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500)),
            Text('${(percent * 100).toInt()}%', style: GoogleFonts.spaceMono(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percent,
          backgroundColor: Colors.grey.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  // Helper: Weak Card
  Widget _buildWeakCard(String char, String romaji) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFFD94F3D).withOpacity(0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFD94F3D).withOpacity(0.3))),
      child: Column(
        children: [
          Text(char, style: GoogleFonts.notoSerifJp(fontSize: 18, color: const Color(0xFFD94F3D), fontWeight: FontWeight.bold)),
          Text(romaji, style: GoogleFonts.spaceMono(fontSize: 8, color: const Color(0xFFD94F3D).withOpacity(0.8))),
        ],
      ),
    );
  }
}