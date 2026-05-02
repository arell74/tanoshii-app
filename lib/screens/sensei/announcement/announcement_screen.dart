import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final TextEditingController _broadcastController = TextEditingController();

  // Data dummy riwayat pengumuman untuk simulasi
  final List<Map<String, dynamic>> _history = [
    {
      'message': 'Pengingat: Kuis Hiragana Dasar batas akhirnya besok siang ya!',
      'time': '2j lalu',
      'received': 32,
      'read': 12,
    },
    {
      'message': 'Selamat untuk Dewi yang mencapai akurasi 91% minggu ini! 🏆',
      'time': '1h lalu',
      'received': 32,
      'read': 32,
    },
    {
      'message': 'Modul Materi Kanji N5 sudah dibuka. Silakan pelajari materinya.',
      'time': 'kemarin',
      'received': 32,
      'read': 30,
    },
  ];

  void _sendBroadcast() {
    if (_broadcastController.text.trim().isEmpty) return;

    // Menambah pengumuman baru ke urutan paling atas
    setState(() {
      _history.insert(0, {
        'message': _broadcastController.text.trim(),
        'time': 'baru saja',
        'received': 0, // Simulasi awal kirim belum ada yang terima
        'read': 0,
      });
      _broadcastController.clear();
      FocusScope.of(context).unfocus(); // Tutup keyboard
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pengumuman berhasil dikirim ke seluruh kelas!'),
        backgroundColor: const Color(0xFF7C4F8A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _broadcastController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color headerPurple = Color(0xFF5A3D7A); // Ungu gelap untuk header[cite: 1]
    const Color purple = Color(0xFF7C4F8A); // Ungu aksen[cite: 1]
    const Color indigo = Color(0xFF3D5A8A);
    const Color gold = Color(0xFFC9A84C);
    const Color bgColor = Color(0xFFF5F4F0);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER UNGU ──[cite: 1]
            Container(
              color: headerPurple,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pengumuman', style: GoogleFonts.dmSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(Icons.add, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text('BUAT', style: GoogleFonts.spaceMono(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // ── BROADCAST KE SEMUA SISWA ──[cite: 1]
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: purple.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: purple.withOpacity(0.2))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BROADCAST KE SEMUA SISWA', style: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: purple)),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _broadcastController,
                          maxLines: 3,
                          style: GoogleFonts.dmSans(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Tulis pesan untuk kelas...',
                            hintStyle: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey[500]),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black12)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black12)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: purple)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _sendBroadcast,
                            icon: const Icon(Icons.campaign_rounded, color: Colors.white, size: 18),
                            label: Text('KIRIM KE SEMUA', style: GoogleFonts.spaceMono(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: purple,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── RIWAYAT PENGUMUMAN ──[cite: 1]
                  Text('RIWAYAT PENGUMUMAN', style: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.grey[700])),
                  const SizedBox(height: 12),
                  
                  // Menampilkan daftar history secara dinamis
                  ..._history.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withOpacity(0.2))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(item['message'], style: GoogleFonts.dmSans(fontSize: 13, color: const Color(0xFF1A1A2E), height: 1.5)),
                              ),
                              const SizedBox(width: 12),
                              Text(item['time'], style: GoogleFonts.spaceMono(fontSize: 10, color: Colors.grey[500])),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Read Receipts Badges[cite: 1]
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: indigo.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                child: Text('✓ ${item['received']} diterima', style: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold, color: indigo)),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: gold.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                child: Text('👁 ${item['read']} dibaca', style: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold, color: gold)),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }).toList(),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}