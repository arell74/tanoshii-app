import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class FlashcardScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const FlashcardScreen({Key? key, this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);
    const Color paper = Color(0xFFFAF7F2);
    const Color sageLight = Color(0xFF6AAB9B);

    return Scaffold(
      backgroundColor: paper,
      body: Column(
        children: [
          // ── HEADER SECTION ──
          Container(
            color: ink,
            padding: const EdgeInsets.fromLTRB(18, 50, 18, 16),
            child: Row(
              children: [
                // Tombol Back
                InkWell(
                  onTap: onBack,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.chevron_left, color: paper),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hiragana — Baris あ', style: GoogleFonts.dmSans(color: paper, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('FLASHCARD MODE', style: GoogleFonts.spaceMono(color: paper.withOpacity(0.5), fontSize: 10, letterSpacing: 1)),
                    ],
                  ),
                ),
                Text('7/46', style: GoogleFonts.spaceMono(color: gold, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Progress Bar Header
          LinearProgressIndicator(
            value: 0.35,
            backgroundColor: ink.withOpacity(0.8),
            valueColor: const AlwaysStoppedAnimation<Color>(vermillion),
            minHeight: 3,
          ),

          // ── BODY SECTION ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 1. FLASHCARD DENGAN ANIMASI FLIP
                  const Expanded(
                    flex: 4,
                    child: FlipCardWidget(
                      frontChar: 'き',
                      backRomaji: 'ki',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. KANA GRID (Menampilkan status hafalan)
                  Expanded(
                    flex: 3,
                    child: _buildKanaGrid(ink, vermillion, sageLight),
                  ),
                  const SizedBox(height: 16),

                  // 3. ACTION BUTTONS
                  Row(
                    children: [
                      Expanded(child: _buildActionButton('✗', 'Belum', const Color(0xFFFDE8E6), vermillion)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildActionButton('△', 'Sulit', const Color(0xFFFEF6E0), const Color(0xFFB8860B))),
                      const SizedBox(width: 10),
                      Expanded(child: _buildActionButton('✓', 'Hafal', const Color(0xFFE6F5EE), const Color(0xFF4A7C6F))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper: Kana Grid
  Widget _buildKanaGrid(Color ink, Color vermillion, Color sageLight) {
    // Data dummy 
    final List<Map<String, dynamic>> kanaList = [
      {'k': 'あ', 'r': 'a', 'status': 'done'},
      {'k': 'い', 'r': 'i', 'status': 'done'},
      {'k': 'う', 'r': 'u', 'status': 'done'},
      {'k': 'え', 'r': 'e', 'status': 'done'},
      {'k': 'お', 'r': 'o', 'status': 'done'},
      {'k': 'か', 'r': 'ka', 'status': 'done'},
      {'k': 'き', 'r': 'ki', 'status': 'active'},
      {'k': 'く', 'r': 'ku', 'status': 'default'},
      {'k': 'け', 'r': 'ke', 'status': 'default'},
      {'k': 'こ', 'r': 'ko', 'status': 'default'},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: kanaList.length,
      itemBuilder: (context, index) {
        final item = kanaList[index];
        Color bgColor = Colors.white;
        Color textColor = ink;
        Color romajiColor = ink.withOpacity(0.4);

        if (item['status'] == 'done') {
          bgColor = sageLight;
          textColor = Colors.white;
          romajiColor = Colors.white70;
        } else if (item['status'] == 'active') {
          bgColor = vermillion;
          textColor = Colors.white;
          romajiColor = Colors.white70;
        }

        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: ink.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item['k'], style: GoogleFonts.notoSerifJp(fontSize: 18, color: textColor, fontWeight: FontWeight.bold)),
              Text(item['r'], style: GoogleFonts.spaceMono(fontSize: 10, color: romajiColor)),
            ],
          ),
        );
      },
    );
  }

  // Widget Helper: Action Button
  Widget _buildActionButton(String icon, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(icon, style: TextStyle(fontSize: 20, color: textColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: textColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────
// LOGIKA ANIMASI FLIP 3D KARTU
// ────────────────────────────────────────────────────────
class FlipCardWidget extends StatefulWidget {
  final String frontChar;
  final String backRomaji;

  const FlipCardWidget({
    Key? key,
    required this.frontChar,
    required this.backRomaji,
  }) : super(key: key);

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400), // Durasi balikan kartu
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_controller.isAnimating) return;
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    isFront = !isFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Putaran sudut (menggunakan pi dari dart:math)
          final angle = _animation.value * math.pi;
          // Matrix 3D untuk efek kedalaman
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateY(angle);

          // Cek apakah kartu sudah lewat dari 90 derajat
          final isBackVisible = angle >= (math.pi / 2);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: isBackVisible
                ? Transform(
                    // Harus di-rotate lagi agar tulisan belakang tidak terbalik (mirror)
                    transform: Matrix4.identity()..rotateY(math.pi),
                    alignment: Alignment.center,
                    child: _buildCardFace(isFrontFace: false),
                  )
                : _buildCardFace(isFrontFace: true),
          );
        },
      ),
    );
  }

  Widget _buildCardFace({required bool isFrontFace}) {
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withOpacity(0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Stack(
        children: [
          // Garis atas kartu
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: 6,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [vermillion, gold]),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
            ),
          ),
          // Isi Konten Kartu
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isFrontFace ? widget.frontChar : widget.backRomaji,
                  style: GoogleFonts.notoSerifJp(
                    fontSize: isFrontFace ? 80 : 64,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isFrontFace ? 'Tap kartu untuk melihat jawaban' : 'Cara bacanya adalah ${widget.backRomaji}',
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    color: const Color(0xFF1A1A2E).withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          // Indikator Rotate di pojok
          Positioned(
            bottom: 16, right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('↻ FLIP', style: GoogleFonts.spaceMono(fontSize: 10, color: const Color(0xFF1A1A2E).withOpacity(0.4))),
            ),
          )
        ],
      ),
    );
  }
}