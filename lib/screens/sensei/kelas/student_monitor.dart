import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'student_detail_screen.dart';

class StudentMonitorScreen extends StatefulWidget {
  const StudentMonitorScreen({Key? key}) : super(key: key);

  @override
  State<StudentMonitorScreen> createState() => _StudentMonitorScreenState();
}

class _StudentMonitorScreenState extends State<StudentMonitorScreen> {
  String _selectedFilter = 'SEMUA'; // Filter aktif: SEMUA, PERLU BANTUAN, TOP

  @override
  Widget build(BuildContext context) {
    const Color indigo = Color(0xFF3D5A8A);
    const Color vermillion = Color(0xFFD94F3D);
    const Color sage = Color(0xFF4A7C6F);
    const Color gold = Color(0xFFC9A84C);
    const Color bgColor = Color(0xFFF5F4F0);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER & SEARCH BAR ──
            Container(
              color: indigo,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daftar Siswa',
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Search Box
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      style: GoogleFonts.dmSans(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Cari nama siswa...',
                        hintStyle: GoogleFonts.dmSans(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white60,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── FILTER TABS ──
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildFilterChip('SEMUA', indigo),
                  const SizedBox(width: 8),
                  _buildFilterChip('PERLU BANTUAN', vermillion),
                  const SizedBox(width: 8),
                  _buildFilterChip('TOP', gold),
                ],
              ),
            ),

            // ── LIST SISWA ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildStudentCard('Raiden Eii', 84, sage, 'R'),
                  _buildStudentCard(
                    'Zani',
                    28,
                    vermillion,
                    'z',
                    isWarning: true,
                  ),
                  _buildStudentCard('Hiyukii', 61, sage, 'H'),
                  _buildStudentCard('Haimiya Mio', 91, gold, 'HM', isTop: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, Color color) {
    bool isActive = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? color
              : const Color(
                  0xFFECEAE4,
                ), // Sesuai warna background abu wireframe[cite: 1]
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(String name, int accuracy, Color progressColor, String initial, {bool isWarning = false, bool isTop = false}) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail saat di-klik
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentDetailScreen(
              name: name,
              accuracy: accuracy,
              themeColor: progressColor,
              initial: initial,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.15)),
        ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: progressColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: GoogleFonts.dmSans(
                color: progressColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Nama & Progress Bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 6),
                // Custom Progress Bar Mini[cite: 1]
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: progressColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor:
                        accuracy / 100, // Menyesuaikan lebar bar dengan akurasi
                    child: Container(
                      decoration: BoxDecoration(
                        color: progressColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Akurasi & Badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isWarning)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: const Text('⚠️', style: TextStyle(fontSize: 10)),
                )
              else if (isTop)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: const Text('🏆', style: TextStyle(fontSize: 10)),
                ),
              const SizedBox(height: 4),
              Text(
                '$accuracy%',
                style: GoogleFonts.spaceMono(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: progressColor,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}
