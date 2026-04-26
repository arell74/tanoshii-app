import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color paper = Color(0xFFFAF7F2);
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);
    const Color sage = Color(0xFF4A7C6F);

    return Scaffold(
      backgroundColor: paper,
      body: Column(
        children: [
          // ── HEADER SECTION ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 50, 18, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [ink, Color(0xFF2D1A3E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progres Belajar',
                  style: GoogleFonts.notoSerifJp(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '学習の進捗 · APRIL 2026',
                  style: GoogleFonts.spaceMono(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          // ── BODY SECTION ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // gambar pp
                Center(
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/boruto.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                // username
                Center(
                  child: Text(
                    "Farel Fauzan",
                    style: GoogleFonts.dmSans(
                      color: ink,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 19),
                // 1. STATS ROW
                Row(
                  children: [
                    Expanded(child: _buildStatCard('7', 'Streak', vermillion)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatCard('640', 'XP Total', gold)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatCard('84%', 'Akurasi', sage)),
                  ],
                ),
                const SizedBox(height: 16),

                // 2. MASTERY CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: ink.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PENGUASAAN AKSARA',
                        style: GoogleFonts.spaceMono(
                          fontSize: 10,
                          color: ink.withOpacity(0.4),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMasteryItem('Hiragana', 0.26, vermillion),
                      const SizedBox(height: 12),
                      _buildMasteryItem(
                        'Katakana',
                        0.10,
                        const Color(0xFF3D5A8A),
                      ),
                      const SizedBox(height: 12),
                      _buildMasteryItem('Kanji N5', 0.05, sage),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. HEATMAP CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: ink.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AKTIVITAS 4 MINGGU TERAKHIR',
                        style: GoogleFonts.spaceMono(
                          fontSize: 10,
                          color: ink.withOpacity(0.4),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Heatmap Grid (7x4)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                            ),
                        itemCount: 28,
                        itemBuilder: (context, index) {
                          // Logika dummy untuk warna heatmap
                          int intensity = (index * 7) % 5;
                          return Container(
                            decoration: BoxDecoration(
                              color: _getHeatmapColor(intensity, vermillion),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Stat Card
  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.spaceMono(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.spaceMono(
              fontSize: 8,
              color: const Color(0xFF1A1A2E).withOpacity(0.4),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Mastery Bar
  Widget _buildMasteryItem(String name, double percent, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            Text(
              '${(percent * 100).toInt()}%',
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percent,
          backgroundColor: const Color(0xFF1A1A2E).withOpacity(0.06),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  // Helper: Heatmap Color Logic
  Color _getHeatmapColor(int intensity, Color baseColor) {
    if (intensity == 0) return const Color(0xFF1A1A2E).withOpacity(0.05);
    return baseColor.withOpacity(0.2 * intensity);
  }
}
