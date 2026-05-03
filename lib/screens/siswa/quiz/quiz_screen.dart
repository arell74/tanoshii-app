import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizScreen extends StatefulWidget {
  final String quizTitle;
  final String module;
  final List<Map<String, dynamic>> questions;
  final VoidCallback? onBack;

  const QuizScreen({
    Key? key,
    required this.quizTitle,
    required this.module,
    required this.questions,
    this.onBack,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int _lives = 3; // Nyawa awal

  bool _isAnswered = false; // Mencegah user tap berkali-kali
  int? _selectedOptionIndex;

  void _checkAnswer(int selectedIndex, bool isCorrect) {
    if (_isAnswered) return; // Kalau sudah jawab, jangan bisa ditap lagi

    setState(() {
      _isAnswered = true;
      _selectedOptionIndex = selectedIndex;

      if (isCorrect) {
        _score += 10; // Tambah skor jika benar
      } else {
        _lives -= 1; // Kurangi nyawa jika salah
      }
    });

    // Tunggu 1.5 detik agar user bisa melihat animasi benar/salah, lalu lanjut
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_lives <= 0) {
      _showResultDialog('Game Over! Nyawa kamu habis 💔', _score);
      return;
    }

    if (_currentIndex < widget.questions.length - 1) {
      // Lanjut soal berikutnya
      setState(() {
        _currentIndex++;
        _isAnswered = false;
        _selectedOptionIndex = null;
      });
    } else {
      // Kuis selesai
      _showResultDialog('Kuis Selesai! Kerja Bagus! 🎉', _score);
    }
  }

  void _showResultDialog(String title, int finalScore) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Total Skor Kamu: $finalScore\nModul: ${widget.module}',
            style: GoogleFonts.dmSans(),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);

              if (widget.onBack != null) {
                widget.onBack!();
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(
              'Kembali',
              style: GoogleFonts.dmSans(
                color: const Color(0xFF3D5A8A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color indigo = Color(0xFF3D5A8A);
    const Color goldLight = Color(0xFFE8CC7E);
    const Color sage = Color(0xFF4A7C6F);
    const Color vermillion = Color(0xFFD94F3D);
    const Color paper = Color(0xFFFAF7F2);

    final currentQ = widget.questions[_currentIndex];
    final options = currentQ['options'] as List<Map<String, dynamic>>;

    // Membuat string hati berdasarkan sisa nyawa
    String hearts = '❤️' * _lives + '💔' * (3 - _lives);

    return Scaffold(
      backgroundColor: paper,
      body: Column(
        children: [
          // ── HEADER SECTION (INDIGO) ──
          Container(
            color: indigo,
            padding: const EdgeInsets.fromLTRB(18, 50, 18, 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.spaceMono(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        children: [
                          const TextSpan(text: 'Skor: '),
                          TextSpan(
                            text: '$_score',
                            style: const TextStyle(
                              color: goldLight,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(hearts, style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                // Progress Bar Kuis Dinamis
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / widget.questions.length,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(goldLight),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            ),
          ),

          // ── BODY SECTION ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'SOAL ${_currentIndex + 1} / ${widget.questions.length} · ${widget.module.toUpperCase()}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      letterSpacing: 2,
                      color: ink.withOpacity(0.4),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Kotak Pertanyaan
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: ink.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          currentQ['question'],
                          style: GoogleFonts.spaceMono(
                            fontSize: 12,
                            color: ink.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentQ['char'],
                          style: GoogleFonts.notoSerifJp(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: ink,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pilihan Ganda (Grid 2x2 Dinamis)
                  Expanded(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.8,
                          ),
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isCorrect = option['isCorrect'] as bool;

                        // Logika Pewarnaan Opsi
                        Color? stateColor;
                        String statusMark = '';

                        if (_isAnswered) {
                          if (isCorrect) {
                            stateColor =
                                sage; // Hijau jika itu jawaban yang benar
                            statusMark = ' ✓';
                          } else if (_selectedOptionIndex == index) {
                            stateColor =
                                vermillion; // Merah jika itu jawaban salah yang diklik
                            statusMark = ' ✗';
                          }
                        }

                        return _buildOptionBtn(
                          index: index,
                          romaji: option['romaji'],
                          kana: '${option['kana']}$statusMark',
                          stateColor: stateColor,
                          isSelected: _selectedOptionIndex == index,
                          onTap: () => _checkAnswer(index, isCorrect),
                        );
                      },
                    ),
                  ),

                  // Hint Box (Muncul di bawah)
                  // Hanya muncul jika ada hint untuk pertanyaan ini
                  if (currentQ['hint'] != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFF8EC), Color(0xFFFEF3D6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('💡', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              currentQ['hint'],
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: ink.withOpacity(0.7),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk membuat tombol opsi
  Widget _buildOptionBtn({
    required int index,
    required String romaji,
    required String kana,
    Color? stateColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final bool hasState = stateColor != null;
    final Color bgColor = hasState ? stateColor.withOpacity(0.1) : Colors.white;
    final Color borderColor = hasState
        ? stateColor
        : (isSelected ? const Color(0xFF1A1A2E) : Colors.transparent);
    final Color textColor = hasState ? stateColor : const Color(0xFF1A1A2E);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: hasState
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF1A1A2E).withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              romaji,
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              kana,
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                color: hasState
                    ? textColor
                    : const Color(0xFF1A1A2E).withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
