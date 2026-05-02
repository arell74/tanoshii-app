import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================================
// 1. HALAMAN UTAMA: DAFTAR KUIS
// ============================================================================
class QuizManagementScreen extends StatelessWidget {
  const QuizManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color indigo = Color(0xFF3D5A8A);
    const Color vermillion = Color(0xFFD94F3D);
    const Color bgColor = Color(0xFFF5F4F0);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER BIRU ──
            Container(
              color: indigo,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kelola Kuis',
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Tombol + BUAT
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateQuizScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: vermillion,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'BUAT',
                            style: GoogleFonts.spaceMono(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── LIST KUIS ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'KUIS AKTIF (2)',
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildQuizCard(
                    'Kuis Hiragana Dasar',
                    '10 soal',
                    '18 dikerjakan',
                    'rata² 76%',
                    isActive: true,
                  ),
                  _buildQuizCard(
                    'Evaluasi Katakana',
                    '15 soal',
                    '7 dikerjakan',
                    'rata² 60%',
                    isActive: true,
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'DRAFT (1)',
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildQuizCard(
                    'Ujian Kanji N5',
                    '5 soal',
                    'belum dipublish',
                    '-',
                    isActive: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Kartu Kuis
  Widget _buildQuizCard(
    String title,
    String stat1,
    String stat2,
    String stat3, {
    required bool isActive,
  }) {
    const Color indigo = Color(0xFF3D5A8A);
    const Color sage = Color(0xFF4A7C6F);
    const Color gold = Color(0xFFC9A84C);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isActive ? indigo.withOpacity(0.08) : Colors.transparent,
        border: Border.all(
          color: isActive
              ? indigo.withOpacity(0.2)
              : Colors.grey.withOpacity(0.3),
          style: isActive ? BorderStyle.solid : BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? sage.withOpacity(0.15)
                      : gold.withOpacity(0.15),
                  border: Border.all(
                    color: isActive
                        ? sage.withOpacity(0.3)
                        : gold.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isActive ? 'AKTIF' : 'DRAFT',
                  style: GoogleFonts.spaceMono(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isActive ? sage : gold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatMini(stat1),
              if (isActive) ...[
                const SizedBox(width: 16),
                _buildStatMini(stat2),
                const SizedBox(width: 16),
                _buildStatMini(stat3),
              ] else ...[
                const SizedBox(width: 16),
                _buildStatMini(stat2),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatMini(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Color(0xFF3D5A8A),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }
}

// ============================================================================
// 2. HALAMAN KEDUA: FORM BUAT KUIS BARU
// ============================================================================
class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({Key? key}) : super(key: key);

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  // State form
  String _selectedModule = 'HIRAGANA';
  String _selectedType = 'CHAR→ROMAJI';
  int _questionCount = 10;
  int _timeLimit = 15;
  bool _allowReview = true;

  @override
  Widget build(BuildContext context) {
    const Color indigo = Color(0xFF3D5A8A);
    const Color vermillion = Color(0xFFD94F3D);
    const Color bgColor = Color(0xFFF5F4F0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: indigo,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Buat Kuis Baru',
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── JUDUL ──
            _buildSectionLabel('JUDUL KUIS'),
            TextField(
              style: GoogleFonts.dmSans(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Misal: Kuis Evaluasi Minggu 1',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── MODUL MATERI ──
            _buildSectionLabel('MODUL MATERI'),
            Row(
              children: [
                _buildToggleChip(
                  'HIRAGANA',
                  'あ',
                  _selectedModule == 'HIRAGANA',
                  vermillion,
                  () => setState(() => _selectedModule = 'HIRAGANA'),
                ),
                const SizedBox(width: 8),
                _buildToggleChip(
                  'KATAKANA',
                  'ア',
                  _selectedModule == 'KATAKANA',
                  vermillion,
                  () => setState(() => _selectedModule = 'KATAKANA'),
                ),
                const SizedBox(width: 8),
                _buildToggleChip(
                  'KANJI',
                  '字',
                  _selectedModule == 'KANJI',
                  vermillion,
                  () => setState(() => _selectedModule = 'KANJI'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── TIPE SOAL ──
            _buildSectionLabel('TIPE SOAL'),
            Row(
              children: [
                _buildToggleChip(
                  'CHAR→ROMAJI',
                  '',
                  _selectedType == 'CHAR→ROMAJI',
                  indigo,
                  () => setState(() => _selectedType = 'CHAR→ROMAJI'),
                ),
                const SizedBox(width: 8),
                _buildToggleChip(
                  'ROMAJI→CHAR',
                  '',
                  _selectedType == 'ROMAJI→CHAR',
                  indigo,
                  () => setState(() => _selectedType = 'ROMAJI→CHAR'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── COUNTERS ──
            Row(
              children: [
                Expanded(
                  child: _buildCounter(
                    'JUMLAH SOAL',
                    '$_questionCount',
                    () => setState(() {
                      if (_questionCount > 5) _questionCount -= 5;
                    }),
                    () => setState(() => _questionCount += 5),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCounter(
                    'BATAS WAKTU',
                    '${_timeLimit}m',
                    () => setState(() {
                      if (_timeLimit > 5) _timeLimit -= 5;
                    }),
                    () => setState(() => _timeLimit += 5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── SWITCH: IZINKAN SISWA ──
            _buildSectionLabel('IZINKAN SISWA'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lihat jawaban benar setelah selesai',
                    style: GoogleFonts.dmSans(fontSize: 13),
                  ),
                  Switch(
                    value: _allowReview,
                    activeColor: indigo,
                    onChanged: (val) => setState(() => _allowReview = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // ── TOMBOL AKSI BAWAH ──
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: indigo,
                      side: const BorderSide(color: indigo),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'SIMPAN DRAFT',
                      style: GoogleFonts.spaceMono(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Kuis berhasil dipublikasikan ke siswa!',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: indigo,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'PUBLIKASIKAN',
                      style: GoogleFonts.spaceMono(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.spaceMono(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildToggleChip(
    String label,
    String prefix,
    bool isActive,
    Color activeColor,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? activeColor.withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: isActive
                  ? activeColor.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.2),
              width: isActive ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            prefix.isNotEmpty ? '$prefix $label' : label,
            style: GoogleFonts.spaceMono(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: isActive ? activeColor : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCounter(
    String label,
    String value,
    VoidCallback onMinus,
    VoidCallback onPlus,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(label),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 16),
                onPressed: onMinus,
              ),
              Text(
                value,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 16),
                onPressed: onPlus,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
