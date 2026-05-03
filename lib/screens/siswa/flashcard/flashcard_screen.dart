import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/flashcard_data.dart';
import 'dart:math' as math;

class FlashcardScreen extends StatefulWidget {
  final String moduleTitle; 
  final VoidCallback? onBack;

  const FlashcardScreen({
    Key? key, 
    required this.moduleTitle, 
    this.onBack,
  }) : super(key: key);

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int _currentIndex = 0;
  late List<Map<String, String>> _currentCards;

  @override
  void initState() {
    super.initState();
    // Ambil data sesuai judul modul yang dilempar dari layar sebelumnya
    _currentCards = flashcardDatabase[widget.moduleTitle] ?? [];
  }

  // Fungsi untuk pindah ke kartu selanjutnya
  void _nextCard() {
    if (_currentIndex < _currentCards.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // Jika sudah habis, munculkan notifikasi dan kembali ke halaman sebelumnya
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selamat! Modul ${widget.moduleTitle} Selesai! 🎉'),
          backgroundColor: const Color(0xFF4A7C6F),
        ),
      );
      if (widget.onBack != null) {
        widget.onBack!();
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);
    const Color paper = Color(0xFFFAF7F2);
    const Color sageLight = Color(0xFF6AAB9B);

    // Layar pengaman jika data modul kosong atau tidak ditemukan
    if (_currentCards.isEmpty) {
      return Scaffold(
        backgroundColor: paper,
        body: Center(
          child: Text('Data modul ${widget.moduleTitle} belum tersedia.', style: GoogleFonts.dmSans(color: ink)),
        ),
      );
    }

    final currentCard = _currentCards[_currentIndex];
    final progressValue = (_currentIndex + 1) / _currentCards.length;

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
                // Tombol Back (Mengeksekusi onBack jika ada, jika tidak otomatis Pop)
                InkWell(
                  onTap: widget.onBack ?? () => Navigator.pop(context),
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
                      // Judul Dinamis berdasarkan parameter moduleTitle
                      Text(widget.moduleTitle, style: GoogleFonts.dmSans(color: paper, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('FLASHCARD MODE', style: GoogleFonts.spaceMono(color: paper.withOpacity(0.5), fontSize: 10, letterSpacing: 1)),
                    ],
                  ),
                ),
                // Indikator Angka Dinamis
                Text('${_currentIndex + 1}/${_currentCards.length}', style: GoogleFonts.spaceMono(color: gold, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          // Progress Bar Header Dinamis
          LinearProgressIndicator(
            value: progressValue,
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
                  Expanded(
                    flex: 4,
                    child: FlipCardWidget(
                      // ValueKey memastikan status flip ter-reset setiap kali index berganti
                      key: ValueKey<int>(_currentIndex), 
                      frontChar: currentCard['char'] ?? '?',
                      backRomaji: currentCard['romaji'] ?? currentCard['r'] ?? '?', 
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
                      Expanded(child: _buildActionButton('✗', 'Belum', const Color(0xFFFDE8E6), vermillion, _nextCard)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildActionButton('△', 'Sulit', const Color(0xFFFEF6E0), const Color(0xFFB8860B), _nextCard)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildActionButton('✓', 'Hafal', const Color(0xFFE6F5EE), const Color(0xFF4A7C6F), _nextCard)),
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

  // Widget Helper: Kana Grid Dinamis
  Widget _buildKanaGrid(Color ink, Color vermillion, Color sageLight) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _currentCards.length,
      itemBuilder: (context, index) {
        final item = _currentCards[index];
        Color bgColor = Colors.white;
        Color textColor = ink;
        Color romajiColor = ink.withOpacity(0.4);

        // Logika pewarnaan status grid dinamis
        if (index < _currentIndex) {
          bgColor = sageLight; // Status: Sudah Selesai
          textColor = Colors.white;
          romajiColor = Colors.white70;
        } else if (index == _currentIndex) {
          bgColor = vermillion; // Status: Sedang Aktif
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
              Text(item['char'] ?? '?', style: GoogleFonts.notoSerifJp(fontSize: 18, color: textColor, fontWeight: FontWeight.bold)),
              Text(item['romaji'] ?? item['r'] ?? '?', style: GoogleFonts.spaceMono(fontSize: 10, color: romajiColor)),
            ],
          ),
        );
      },
    );
  }

  // Widget Helper: Action Button Dinamis
  Widget _buildActionButton(String icon, String label, Color bgColor, Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      duration: const Duration(milliseconds: 400), 
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
          final angle = _animation.value * math.pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001) 
            ..rotateY(angle);

          final isBackVisible = angle >= (math.pi / 2);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: isBackVisible
                ? Transform(
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