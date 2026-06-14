import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color paper = Color(0xFFFAF7F2);
    const Color indigo = Color(0xFF3D5A8A);
    const Color vermillion = Color(0xFFD94F3D); // Warna aksen Jepang

    return Scaffold(
      backgroundColor: paper,
      appBar: AppBar(
        backgroundColor: paper,
        elevation: 0,
        iconTheme: const IconThemeData(color: ink),
        title: Text('Tentang NihonGo!', style: GoogleFonts.dmSans(color: ink, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── LOGO APLIKASI ──
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: indigo.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Center(
                child: Text(
                  'あ', // Karakter 'A' Hiragana sebagai logo simpel
                  style: GoogleFonts.notoSansJp(fontSize: 64, color: vermillion, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── NAMA & VERSI ──
            Text(
              'Tanoshii-app',
              style: GoogleFonts.dmSans(color: ink, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Versi 1.0.0 (Beta)',
                style: GoogleFonts.spaceMono(color: indigo, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),

            // ── DESKRIPSI ──
            Text(
              'Aplikasi pembelajaran interaktif yang dirancang khusus untuk memfasilitasi pengguna dalam mempelajari dan menghafal karakter bahasa Jepang (Hiragana, Katakana, dan Kanji) dengan antarmuka yang modern dan menyenangkan.',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(color: ink.withOpacity(0.7), fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 40),

            const Divider(color: Colors.black12),
            const SizedBox(height: 32),

            // ── CREDIT TITLE / PENGEMBANG ──
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'PENGEMBANG APLIKASI',
                style: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold, color: ink.withOpacity(0.5)),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ink.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: indigo.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.developer_mode, color: indigo),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Muhamad Farel Fauzan',
                          style: GoogleFonts.dmSans(color: ink, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mahasiswa Teknik Komputer\nUniversitas Kuningan',
                          style: GoogleFonts.dmSans(color: ink.withOpacity(0.6), fontSize: 12, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // ── FOOTER COPYRIGHT ──
            Text(
              '© 2026 Hak Cipta Dilindungi',
              style: GoogleFonts.dmSans(color: ink.withOpacity(0.4), fontSize: 12),
            ),
            Text(
              'Proyek Interaksi Manusia dan Komputer',
              style: GoogleFonts.dmSans(color: ink.withOpacity(0.4), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}