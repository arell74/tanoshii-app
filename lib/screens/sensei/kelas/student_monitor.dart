import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'student_detail_screen.dart';

class StudentMonitorScreen extends StatefulWidget {
  const StudentMonitorScreen({Key? key}) : super(key: key);

  @override
  State<StudentMonitorScreen> createState() => _StudentMonitorScreenState();
}

class _StudentMonitorScreenState extends State<StudentMonitorScreen> {
  String _selectedFilter = 'SEMUA';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getProgressColor(int accuracy) {
    if (accuracy >= 80) return const Color(0xFFC9A84C); // Gold
    if (accuracy >= 50) return const Color(0xFF4A7C6F); // Sage
    return const Color(0xFFD94F3D); // Vermillion
  }

  @override
  Widget build(BuildContext context) {
    const Color indigo = Color(0xFF3D5A8A);
    const Color vermillion = Color(0xFFD94F3D);
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
                    'Monitor Siswa',
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                      style: GoogleFonts.dmSans(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Cari nama siswa...',
                        hintStyle: GoogleFonts.dmSans(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white60,
                          size: 20,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.white60,
                                  size: 18,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
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

            // ── LIST SISWA DARI FIREBASE ──
            Expanded(
              child: FutureBuilder<DocumentSnapshot>(
                // 1. Ambil data Sensei yang sedang login saat ini
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .get(),
                builder: (context, senseiSnapshot) {
                  if (senseiSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: indigo),
                    );
                  }

                  if (!senseiSnapshot.hasData || !senseiSnapshot.data!.exists) {
                    return Center(
                      child: Text(
                        'Gagal memuat data institusi Sensei.',
                        style: GoogleFonts.dmSans(color: Colors.grey),
                      ),
                    );
                  }

                  // 2. Ekstrak domain Sensei dari database
                  var senseiData =
                      senseiSnapshot.data!.data() as Map<String, dynamic>;
                  String senseiDomain = senseiData['akademiDomain'] ?? '';

                  // 3. Panggil daftar siswa dengan Double-Filter!
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where(
                          'role',
                          isEqualTo: 'Pelajar Akademi',
                        ) // 👈 Hanya siswa resmi
                        .where(
                          'akademiDomain',
                          isEqualTo: senseiDomain,
                        ) // 👈 Hanya dari LPK yang sama
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Terjadi kesalahan data.'),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: indigo),
                        );
                      }

                      var docs = snapshot.data!.docs.where((doc) {
                        var data = doc.data() as Map<String, dynamic>;
                        String name = data['name'] ?? 'Pelajar';
                        int accuracy = data['accuracy'] ?? 0;

                        bool matchesSearch = name.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        );
                        bool matchesFilter = true;

                        if (_selectedFilter == 'PERLU BANTUAN')
                          matchesFilter = accuracy < 50;
                        if (_selectedFilter == 'TOP')
                          matchesFilter = accuracy >= 90;

                        return matchesSearch && matchesFilter;
                      }).toList();

                      if (docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🍃', style: TextStyle(fontSize: 40)),
                              const SizedBox(height: 12),
                              Text(
                                'Belum ada siswa di $senseiDomain',
                                style: GoogleFonts.dmSans(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          var data = docs[index].data() as Map<String, dynamic>;
                          String name = data['name'] ?? 'Pelajar';
                          int accuracy = data['accuracy'] ?? 0;
                          String initial = name.isNotEmpty
                              ? name[0].toUpperCase()
                              : '?';

                          return _buildStudentCard(
                            name,
                            accuracy,
                            _getProgressColor(accuracy),
                            initial,
                            isWarning: accuracy < 50,
                            isTop: accuracy >= 90,
                          );
                        },
                      );
                    },
                  );
                },
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
          color: isActive ? color : const Color(0xFFECEAE4),
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

  Widget _buildStudentCard(
    String name,
    int accuracy,
    Color progressColor,
    String initial, {
    bool isWarning = false,
    bool isTop = false,
  }) {
    return GestureDetector(
      onTap: () {
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
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: progressColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: accuracy / 100,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isWarning)
                  const Text('⚠️', style: TextStyle(fontSize: 12))
                else if (isTop)
                  const Text('🏆', style: TextStyle(fontSize: 12)),
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
