import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const QuizScreen({Key? key, this.onBack}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Simulasi state pilihan user (null = belum milih, 1 = benar, 2 = salah)
  int? selectedOptionIndex;

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color indigo = Color(0xFF3D5A8A);
    const Color goldLight = Color(0xFFE8CC7E);
    const Color sage = Color(0xFF4A7C6F);
    const Color vermillion = Color(0xFFD94F3D);
    const Color paper = Color(0xFFFAF7F2);

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
                        style: GoogleFonts.spaceMono(fontSize: 12, color: Colors.white.withOpacity(0.6)),
                        children: [
                          const TextSpan(text: 'Skor: '),
                          TextSpan(text: '80', style: TextStyle(color: goldLight, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const Text('❤️❤️❤️💔', style: TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                // Progress Bar Kuis
                LinearProgressIndicator(
                  value: 0.45,
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
                    'SOAL 5 / 10 · HIRAGANA',
                    style: GoogleFonts.spaceMono(fontSize: 10, letterSpacing: 2, color: ink.withOpacity(0.4), fontWeight: FontWeight.bold),
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
                        BoxShadow(color: ink.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      children: [
                        Text('Apa bacaan karakter ini?', style: GoogleFonts.spaceMono(fontSize: 12, color: ink.withOpacity(0.5))),
                        const SizedBox(height: 16),
                        Text('ね', style: GoogleFonts.notoSerifJp(fontSize: 64, fontWeight: FontWeight.bold, color: ink, height: 1)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pilihan Ganda (Grid 2x2)
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.8,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildOptionBtn(0, 'me', 'め', null),
                        // Simulasi opsi benar (index 1)
                        _buildOptionBtn(1, 'ne', 'ね ✓', sage, isSelected: selectedOptionIndex == 1),
                        // Simulasi opsi salah (index 2)
                        _buildOptionBtn(2, 'na', 'な ✗', vermillion, isSelected: selectedOptionIndex == 2),
                        _buildOptionBtn(3, 'nu', 'ぬ', null),
                      ],
                    ),
                  ),

                  // Hint Box (Muncul di bawah)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFFF8EC), Color(0xFFFEF3D6)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('💡', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.dmSans(fontSize: 12, color: ink.withOpacity(0.7), height: 1.5),
                              children: [
                                const TextSpan(text: 'ね (ne) ', style: TextStyle(fontWeight: FontWeight.bold)),
                                const TextSpan(text: 'berasal dari kanji 根 yang berarti "akar". Ingat: bentuknya seperti huruf "ne"!'),
                              ],
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
  Widget _buildOptionBtn(int index, String romaji, String kana, Color? stateColor, {bool isSelected = false}) {
    final bool hasState = stateColor != null;
    final Color bgColor = hasState ? stateColor.withOpacity(0.1) : Colors.white;
    final Color borderColor = hasState ? stateColor : Colors.transparent;
    final Color textColor = hasState ? stateColor : const Color(0xFF1A1A2E);

    return InkWell(
      onTap: () {
        setState(() {
          selectedOptionIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: hasState ? [] : [
            BoxShadow(color: const Color(0xFF1A1A2E).withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(romaji, style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 2),
            Text(kana, style: GoogleFonts.spaceMono(fontSize: 10, color: hasState ? textColor : const Color(0xFF1A1A2E).withOpacity(0.4))),
          ],
        ),
      ),
    );
  }
}