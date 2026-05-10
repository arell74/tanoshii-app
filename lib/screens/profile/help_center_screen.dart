import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color paper = Color(0xFFFAF7F2);
    const Color indigo = Color(0xFF3D5A8A);

    return Scaffold(
      backgroundColor: paper,
      appBar: AppBar(
        backgroundColor: paper,
        elevation: 0,
        iconTheme: const IconThemeData(color: ink),
        title: Text('Pusat Bantuan', style: GoogleFonts.dmSans(color: ink, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── HEADER ILLUSTRATION / TEXT ──
            Center(
              child: Icon(Icons.help_outline_rounded, size: 64, color: indigo.withOpacity(0.8)),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Ada yang bisa kami bantu?',
                style: GoogleFonts.dmSans(color: ink, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Temukan jawaban untuk pertanyaan umum atau hubungi tim dukungan kami di bawah ini.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(color: ink.withOpacity(0.6), fontSize: 14),
              ),
            ),
            const SizedBox(height: 40),

            // ── FAQ SECTION (PERTANYAAN UMUM) ──
            Text('PERTANYAAN UMUM (FAQ)', style: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold, color: ink.withOpacity(0.5))),
            const SizedBox(height: 12),

            _buildFAQItem(
              'Bagaimana cara mendapatkan XP?',
              'Anda bisa mendapatkan XP dengan cara menyelesaikan kuis Hiragana, Katakana, dan Kanji, serta login setiap hari.',
              ink, indigo
            ),
            _buildFAQItem(
              'Apakah saya bisa mengubah level saya?',
              'Level akan meningkat secara otomatis seiring dengan bertambahnya jumlah XP yang Anda kumpulkan dari pembelajaran.',
              ink, indigo
            ),
            _buildFAQItem(
              'Bagaimana cara mengganti role menjadi Guru?',
              'Role Guru (Sensei) hanya bisa diberikan oleh Admin sistem. Silakan hubungi kami untuk pendaftaran akses pengajar.',
              ink, indigo
            ),
            _buildFAQItem(
              'Siapa pengembang aplikasi ini?',
              'NihonGo! dikembangkan secara khusus sebagai proyek pengembangan antarmuka (UI/UX) untuk memberikan pengalaman belajar bahasa Jepang yang modern dan interaktif.',
              ink, indigo
            ),

            const SizedBox(height: 40),

            // ── TOMBOL HUBUNGI KAMI ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: indigo.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: indigo.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  Text(
                    'Masih butuh bantuan?',
                    style: GoogleFonts.dmSans(color: ink, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tim dukungan kami siap membantu masalah teknis Anda.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(color: ink.withOpacity(0.6), fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Membuka aplikasi Email...'),
                            backgroundColor: indigo,
                          ),
                        );
                      },
                      icon: const Icon(Icons.email_outlined, color: Colors.white, size: 18),
                      label: Text('Hubungi Support', style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: indigo,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget custom untuk membuat sistem Buka-Tutup (Accordion)
  Widget _buildFAQItem(String question, String answer, Color ink, Color indigo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ink.withOpacity(0.05)),
      ),
      // Theme digunakan untuk menghilangkan garis bawah (border) bawaan ExpansionTile
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: indigo,
          collapsedIconColor: ink.withOpacity(0.4),
          title: Text(
            question,
            style: GoogleFonts.dmSans(fontSize: 14, color: ink, fontWeight: FontWeight.w600),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                answer,
                style: GoogleFonts.dmSans(fontSize: 13, color: ink.withOpacity(0.6), height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}