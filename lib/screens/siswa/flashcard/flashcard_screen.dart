import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/flashcard_data.dart';
import 'dart:math' as math;

class FlashcardScreen extends StatefulWidget {
  final String moduleTitle;
  final String moduleCategory;
  final VoidCallback? onBack;
  final List<Map<String, String>> cardData;

  const FlashcardScreen({
    Key? key,
    required this.moduleTitle,
    required this.moduleCategory,
    required this.cardData,
    this.onBack,
  }) : super(key: key);

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int _currentIndex = 0;
  late List<Map<String, String>> _currentCards;
  int _earnedXp = 0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _currentCards = widget.cardData;
  }

  // Fungsi menyimpan EXP ke Firebase
  Future<void> _saveProgressToFirebase() async {
    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
              'xp': FieldValue.increment(_earnedXp),
              'lastActivity': {
                'category': widget.moduleCategory,
                'title': widget.moduleTitle,
                'progress': _currentIndex + 1,
                'total': _currentCards.length,
                // akurasi
              },
            });
      }
    } catch (e) {
      debugPrint("Gagal menyimpan XP: $e");
    }

    setState(() => _isSaving = false);
  }

  // Fungsi untuk pindah kartu sekaligus menambah XP
  void _nextCard(int xpToAdd) async {
    // Tambahkan XP ke total sementara
    _earnedXp += xpToAdd;

    if (_currentIndex < _currentCards.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // 1. KARTU HABIS -> Simpan data ke Firebase dulu
      await _saveProgressToFirebase();

      // 2. Tampilkan Notifikasi Hasil
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Modul Selesai! Kamu mendapat +$_earnedXp XP 🎉'),
            backgroundColor: const Color(0xFF4A7C6F),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // 3. Kembali ke halaman sebelumnya
        if (widget.onBack != null) {
          widget.onBack!();
        } else {
          Navigator.pop(context);
        }
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

    if (_currentCards.isEmpty) {
      return Scaffold(
        backgroundColor: paper,
        body: Center(
          child: Text(
            'Data modul ${widget.moduleTitle} belum tersedia.',
            style: GoogleFonts.dmSans(color: ink),
          ),
        ),
      );
    }

    final currentCard = _currentCards[_currentIndex];
    final progressValue = (_currentIndex + 1) / _currentCards.length;

    return Scaffold(
      backgroundColor: paper,
      body: Stack(
        children: [
          Column(
            children: [
              // ── HEADER SECTION ──
              Container(
                color: ink,
                padding: const EdgeInsets.fromLTRB(18, 50, 18, 16),
                child: Row(
                  children: [
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
                          Text(
                            widget.moduleTitle,
                            style: GoogleFonts.dmSans(
                              color: paper,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'FLASHCARD MODE',
                            style: GoogleFonts.spaceMono(
                              color: paper.withOpacity(0.5),
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Menampilkan akumulasi XP sementara di pojok kanan atas
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: gold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '+$_earnedXp XP',
                        style: GoogleFonts.spaceMono(
                          color: gold,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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
                      // 1. FLASHCARD
                      Expanded(
                        flex: 4,
                        child: FlipCardWidget(
                          key: ValueKey<int>(_currentIndex),
                          frontChar: currentCard['char'] ?? '?',
                          backRomaji:
                              currentCard['romaji'] ?? currentCard['r'] ?? '?',
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 2. KANA GRID (SEKARANG BISA DI-SCROLL!)
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: ink.withOpacity(0.05)),
                          ),
                          // Gunakan ClipRRect agar saat grid di-scroll, ujungnya tetap melengkung
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: _buildKanaGrid(ink, vermillion, sageLight),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3. ACTION BUTTONS (MENGIRIM NILAI XP)
                      Row(
                        children: [
                          // Tombol Belum -> +0 XP
                          Expanded(
                            child: _buildActionButton(
                              '✗',
                              'Belum',
                              const Color(0xFFFDE8E6),
                              vermillion,
                              () => _nextCard(0),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Tombol Sulit -> +5 XP
                          Expanded(
                            child: _buildActionButton(
                              '△',
                              'Sulit',
                              const Color(0xFFFEF6E0),
                              const Color(0xFFB8860B),
                              () => _nextCard(5),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Tombol Hafal -> +10 XP
                          Expanded(
                            child: _buildActionButton(
                              '✓',
                              'Hafal',
                              const Color(0xFFE6F5EE),
                              const Color(0xFF4A7C6F),
                              () => _nextCard(10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Layer Loading transparan saat menyimpan ke Firebase
          if (_isSaving)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: gold),
              ),
            ),
        ],
      ),
    );
  }

  // Widget Helper: Kana Grid
  Widget _buildKanaGrid(Color ink, Color vermillion, Color sageLight) {
    return GridView.builder(
      // PERUBAHAN: BouncingScrollPhysics agar grid bisa di-scroll dengan efek memantul ala iOS/modern UI
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
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

        if (index < _currentIndex) {
          bgColor = sageLight;
          textColor = Colors.white;
          romajiColor = Colors.white70;
        } else if (index == _currentIndex) {
          bgColor = vermillion;
          textColor = Colors.white;
          romajiColor = Colors.white70;
        }

        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: index > _currentIndex
                  ? ink.withOpacity(0.1)
                  : Colors.transparent,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item['char'] ?? '?',
                style: GoogleFonts.notoSerifJp(
                  fontSize: 18,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item['romaji'] ?? item['r'] ?? '?',
                style: GoogleFonts.spaceMono(fontSize: 10, color: romajiColor),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget Helper: Action Button
  Widget _buildActionButton(
    String icon,
    String label,
    Color bgColor,
    Color textColor,
    VoidCallback onTap,
  ) {
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
            Text(
              icon,
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
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

class _FlipCardWidgetState extends State<FlipCardWidget>
    with SingleTickerProviderStateMixin {
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
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
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
                  isFrontFace
                      ? 'Tap kartu untuk melihat jawaban'
                      : 'Cara bacanya adalah ${widget.backRomaji}',
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    color: const Color(0xFF1A1A2E).withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '↻ FLIP',
                style: GoogleFonts.spaceMono(
                  fontSize: 10,
                  color: const Color(0xFF1A1A2E).withOpacity(0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
