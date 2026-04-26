import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tanoshii_app/screens/auth/login_screen.dart';
import 'siswa/main_navigation.dart';
import '../theme/app_theme.dart'; 

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Definisi warna langsung di sini untuk contoh (idealnya ambil dari AppTheme)
    const Color ink = Color(0xFF1A1A2E);
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);
    const Color paper = Color(0xFFFAF7F2);

    return Scaffold(
      body: Container(
        width: double.infinity,
        // 1. Background Gradient gelap
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ink,
              Color(0xFF2D1A3E), // Ink sedikit keunguan
              Color(0xFF1A2E2A), // Ink sedikit kehijauan
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // 2. Logo Utama "語"
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [vermillion, gold],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: vermillion.withOpacity(0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '語',
                  style: GoogleFonts.notoSerifJp(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Judul Aplikasi
              RichText(
                text: TextSpan(
                  style: GoogleFonts.notoSerifJp(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: paper,
                    letterSpacing: 2,
                  ),
                  children: [
                    const TextSpan(text: 'Nihon'),
                    TextSpan(
                      text: 'Go!',
                      style: TextStyle(color: gold), // Efek gradasi teks bisa disesuaikan nanti
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '日本語を楽しく学ぼう',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: paper.withOpacity(0.6),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // 4. Aksara Dekoratif (Frosted Glass Effect Mockup)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCharBox('あ', paper),
                  const SizedBox(width: 14),
                  _buildCharBox('ア', paper),
                  const SizedBox(width: 14),
                  _buildCharBox('字', paper),
                  const SizedBox(width: 14),
                  _buildCharBox('漢', paper),
                ],
              ),
              
              const Spacer(),

              // 5. Tombol dan Teks Login
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigasi ke halaman Home/Dashboard
                  Navigator.pushReplacement(
                    context,
                    // MaterialPageRoute(builder: (context) => const MainNavigation()),
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: vermillion,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 8,
                  shadowColor: vermillion.withOpacity(0.5),
                ),
                child: Text(
                  'Mulai Belajar',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sudah punya akun? ',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: paper.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    'Masuk',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk membuat kotak huruf
  Widget _buildCharBox(String char, Color paperColor) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        char,
        style: GoogleFonts.notoSerifJp(
          fontSize: 20,
          color: paperColor,
        ),
      ),
    );
  }
}