import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'flashcard_screen.dart';
import '../../../data/flashcard_data.dart';

class SubModuleScreen extends StatelessWidget {
  final String category; // Contoh: 'Hiragana', 'Katakana', 'Kanji'

  const SubModuleScreen({Key? key, required this.category}) : super(key: key);

  List<Map<String, dynamic>> _getDefaultLevels() {
    final rawCards = flashcardDatabase[category] ?? [];
    if (rawCards.isEmpty) return [];

    List<Map<String, dynamic>> levels = [];

    int chunkSize = (category == 'Kanji_N5') ? 10 : 5;

    for (int i = 0; i < rawCards.length; i += chunkSize) {
      int end = (i + chunkSize < rawCards.length)
          ? i + chunkSize
          : rawCards.length;

      List<Map<String, String>> chunk = rawCards.sublist(i, end);
      String subtitleDisplay = chunk.map((c) => c['char']).join(', ');

      levels.add({
        'title': 'Level ${(i ~/ chunkSize) + 1}',
        'subtitle': subtitleDisplay,
        'cards': chunk,
      });
    }

    return levels;
  }

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color purple = Color(0xFF7C4F8A);
    const Color gold = Color(0xFFC9A84C);
    const Color bgColor = Color(0xFFF5F4F0);

    final defaultLevels = _getDefaultLevels();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: ink,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Modul $category',
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. SECTION TUGAS DARI SENSEI (FIREBASE) ──
            Row(
              children: [
                const Icon(
                  Icons.assignment_ind_rounded,
                  color: purple,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'TUGAS DARI SENSEI',
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            StreamBuilder<QuerySnapshot>(
              // Mengambil data dari koleksi 'assigned_modules' yang kategorinya sesuai
              stream: FirebaseFirestore.instance
                  .collection('assigned_modules')
                  .where('category', isEqualTo: category)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: purple),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: purple.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: purple.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        const Text('🍃', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Belum ada tugas tambahan dari Sensei saat ini.',
                            style: GoogleFonts.dmSans(
                              color: purple.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Jika ada tugas dari Sensei
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    var data = doc.data() as Map<String, dynamic>;

                    // Mengubah list dinamis dari Firestore menjadi List<Map<String,String>> yang dimengerti Flashcard
                    List<dynamic> rawCards = data['cards'] ?? [];
                    List<Map<String, String>> customCards = rawCards
                        .map(
                          (c) => {
                            'char': c['char'].toString(),
                            'romaji': c['romaji'].toString(),
                          },
                        )
                        .toList();

                    return _buildLevelCard(
                      context: context,
                      title: data['title'] ?? 'Tugas Khusus',
                      subtitle:
                          'Batas waktu: ${data['deadline'] ?? 'Tidak ada'}',
                      cardData: customCards,
                      isSpecial: true,
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 32),
            const Divider(color: Colors.black12),
            const SizedBox(height: 24),

            // ── 2. SECTION MATERI REGULER (LOKAL) ──
            Text(
              'MATERI REGULER',
              style: GoogleFonts.spaceMono(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),

            ...defaultLevels.map((level) {
              return _buildLevelCard(
                context: context,
                title: level['title'],
                subtitle: level['subtitle'],
                cardData: level['cards'],
                isSpecial: false,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Kartu Level
  Widget _buildLevelCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<Map<String, String>> cardData,
    required bool isSpecial,
  }) {
    const Color ink = Color(0xFF1A1A2E);
    const Color gold = Color(0xFFC9A84C);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSpecial ? gold : Colors.grey.withOpacity(0.2),
          width: isSpecial ? 2 : 1,
        ),
        boxShadow: isSpecial
            ? [BoxShadow(color: gold.withOpacity(0.1), blurRadius: 10)]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigasi ke Flashcard dengan melempar data kartunya langsung!
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlashcardScreen(
                  moduleTitle: title,
                  moduleCategory: category,
                  cardData:
                      cardData, // 👈 Data spesifik level ini dilempar ke Flashcard
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSpecial
                        ? gold.withOpacity(0.1)
                        : ink.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSpecial ? Icons.star_rounded : Icons.play_arrow_rounded,
                    color: isSpecial ? gold : ink,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.dmSans(
                          color: ink,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.spaceMono(
                          color: ink.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${cardData.length} Kartu',
                  style: GoogleFonts.dmSans(
                    color: ink.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
