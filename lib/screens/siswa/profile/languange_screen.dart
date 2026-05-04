import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  // Anggap saja bahasa default saat ini adalah Bahasa Indonesia
  String _selectedLanguageCode = 'id';

  // Daftar bahasa yang tersedia
  final List<Map<String, String>> _languages = [
    {'code': 'id', 'title': 'Bahasa Indonesia', 'subtitle': 'Indonesia'},
    {'code': 'en', 'title': 'English', 'subtitle': 'Inggris'},
    {'code': 'ja', 'title': '日本語 (Nihongo)', 'subtitle': 'Jepang'},
  ];

  void _saveLanguage() {
    // Tampilkan notifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferensi bahasa berhasil disimpan!'),
        backgroundColor: Color(0xFF4A7C6F), // Warna Hijau Sage
      ),
    );

    // Kembali ke halaman profil
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color paper = Color(0xFFFAF7F2);
    const Color indigo = Color(0xFF3D5A8A);

    return Scaffold(
      backgroundColor: paper,
      appBar: AppBar(
        backgroundColor: paper,
        elevation: 0,
        iconTheme: const IconThemeData(color: ink),
        title: Text(
          'Pilih Bahasa',
          style: GoogleFonts.dmSans(
            color: ink,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih bahasa utama yang ingin Anda gunakan untuk antarmuka aplikasi NihonGo!',
              style: GoogleFonts.dmSans(
                color: ink.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),

            // ── LIST BAHASA ──
            Expanded(
              child: ListView.separated(
                itemCount: _languages.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final lang = _languages[index];
                  final isSelected = _selectedLanguageCode == lang['code'];

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedLanguageCode = lang['code']!;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? indigo.withOpacity(0.05)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? indigo : ink.withOpacity(0.05),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang['title']!,
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? indigo : ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lang['subtitle']!,
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: ink.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                          // Ikon ceklis akan muncul jika dipilih
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: indigo,
                              size: 24,
                            )
                          else
                            Icon(
                              Icons.circle_outlined,
                              color: ink.withOpacity(0.2),
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── TOMBOL SIMPAN ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveLanguage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: indigo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Simpan Pengaturan',
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
