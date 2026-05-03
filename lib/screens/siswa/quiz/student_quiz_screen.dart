import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'quiz_screen.dart';

class StudentQuizScreen extends StatelessWidget {
  const StudentQuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);
    const Color paper = Color(0xFFFAF7F2);
    const Color sage = Color(0xFF4A7C6F);

    // Data dummy kuis (Nantinya data ini akan ditarik dari Firebase buatan Sensei)
    final List<Map<String, dynamic>> quizzes = [
      {
        'title': 'Kuis Hiragana Dasar',
        'module': 'Hiragana',
        'questions': 10,
        'time': '15 Menit',
        'status': 'Tersedia', // Tersedia, Selesai
        'score': null,
      },
      {
        'title': 'Evaluasi Katakana',
        'module': 'Katakana',
        'questions': 15,
        'time': '20 Menit',
        'status': 'Tersedia',
        'score': null,
      },
      {
        'title': 'Ujian Kanji N5 - Part 1',
        'module': 'Kanji N5',
        'questions': 20,
        'time': '30 Menit',
        'status': 'Selesai',
        'score': 85,
      },
    ];

    return Scaffold(
      backgroundColor: paper,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER SECTION ──
            Container(
              padding: const EdgeInsets.all(20),
              color: ink,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('UJI KEMAMPUANMU', style: GoogleFonts.spaceMono(color: Colors.white54, fontSize: 10, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text('Daftar Kuis', style: GoogleFonts.dmSans(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            
            // ── BODY / LIST KUIS ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizzes[index];
                  final isDone = quiz['status'] == 'Selesai';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(color: ink.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
                      ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge Modul & Nilai
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDone ? sage.withOpacity(0.1) : vermillion.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                quiz['module'].toString().toUpperCase(),
                                style: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold, color: isDone ? sage : vermillion),
                              ),
                            ),
                            if (isDone)
                              Text('Nilai: ${quiz['score']}', style: GoogleFonts.spaceMono(fontSize: 12, fontWeight: FontWeight.bold, color: gold))
                          ],
                        ),
                        const SizedBox(height: 14),
                        
                        // Judul Kuis
                        Text(quiz['title'], style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: ink)),
                        const SizedBox(height: 10),
                        
                        // Info Waktu & Soal
                        Row(
                          children: [
                            Icon(Icons.format_list_bulleted_rounded, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text('${quiz['questions']} Soal', style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey[600])),
                            const SizedBox(width: 16),
                            Icon(Icons.timer_outlined, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(quiz['time'], style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                        const SizedBox(height: 18),
                        
                        // Tombol Aksi
                        // Tombol Aksi
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!isDone) {
                                // Data dummy untuk dikirim ke layar QuizScreen
                                final dummyQuestions = [
                                  {
                                    'question': 'Apa bacaan karakter ini?',
                                    'char': 'ね',
                                    'hint': 'ね (ne) berasal dari kanji 根 yang berarti "akar". Ingat: bentuknya seperti huruf "ne"!',
                                    'options': [
                                      {'romaji': 'me', 'kana': 'め', 'isCorrect': false},
                                      {'romaji': 'ne', 'kana': 'ね', 'isCorrect': true},
                                      {'romaji': 'na', 'kana': 'な', 'isCorrect': false},
                                      {'romaji': 'nu', 'kana': 'ぬ', 'isCorrect': false},
                                    ]
                                  },
                                  {
                                    'question': 'Karakter mana yang dibaca "ki"?',
                                    'char': 'ki',
                                    'hint': 'ki bentuknya seperti kunci (key).',
                                    'options': [
                                      {'romaji': 'sa', 'kana': 'さ', 'isCorrect': false},
                                      {'romaji': 'chi', 'kana': 'ち', 'isCorrect': false},
                                      {'romaji': 'ki', 'kana': 'き', 'isCorrect': true},
                                      {'romaji': 'ra', 'kana': 'ら', 'isCorrect': false},
                                    ]
                                  }
                                ];

                                // Pindah ke layar pengerjaan kuis
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizScreen(
                                      quizTitle: quiz['title'],
                                      module: quiz['module'],
                                      questions: dummyQuestions, // Lempar data soal
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: const Text('Kamu sudah mengerjakan kuis ini!'),
                                  backgroundColor: sage,
                                ));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDone ? Colors.grey[100] : ink,
                              foregroundColor: isDone ? Colors.grey[400] : Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(isDone ? 'SUDAH DIKERJAKAN' : 'MULAI KUIS', style: GoogleFonts.spaceMono(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}