import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final TextEditingController _broadcastController = TextEditingController();
  bool _isLoading = false;

  // Fungsi untuk mengirim data ke Firestore
  Future<void> _sendBroadcast() async {
    final message = _broadcastController.text.trim();
    if (message.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final senseiDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final senseiDomain = senseiDoc.data()?['akademiDomain'] ?? '';

      await FirebaseFirestore.instance.collection('announcements').add({
        'message': message,
        'akademiDomain': senseiDomain,
        'senderId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'receivedCount': 0,
        'readCount': 0,
      });

      _broadcastController.clear();
      FocusScope.of(context).unfocus();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pengumuman berhasil dikirim ke LPK Anda!'),
            backgroundColor: const Color(0xFF7C4F8A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengirim: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Fungsi pembantu untuk memformat waktu dari Firestore (agar UI tetap cantik)
  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return 'Baru saja';

    final now = DateTime.now();
    final date = timestamp.toDate();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) return '${diff.inMinutes} mnt lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays == 1) return 'Kemarin';
    return '${diff.inDays} hari lalu';
  }

  @override
  void dispose() {
    _broadcastController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color headerPurple = Color(0xFF5A3D7A);
    const Color purple = Color(0xFF7C4F8A);
    const Color indigo = Color(0xFF3D5A8A);
    const Color gold = Color(0xFFC9A84C);
    const Color bgColor = Color(0xFFF5F4F0);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER UNGU ──
            Container(
              color: headerPurple,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pengumuman',
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
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
                ],
              ),
            ),

            Expanded(
              child: Column(
                children: [
                  // ── BROADCAST INPUT ──
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: purple.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BROADCAST KE SEMUA SISWA',
                            style: GoogleFonts.spaceMono(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: purple,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _broadcastController,
                            maxLines: 3,
                            style: GoogleFonts.dmSans(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Tulis pesan untuk kelas...',
                              hintStyle: GoogleFonts.dmSans(
                                fontSize: 13,
                                color: Colors.grey[500],
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: purple),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _sendBroadcast,
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.campaign_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                              label: Text(
                                _isLoading ? 'MENGIRIM...' : 'KIRIM KE SEMUA',
                                style: GoogleFonts.spaceMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: purple,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── RIWAYAT PENGUMUMAN DARI FIREBASE ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'RIWAYAT PENGUMUMAN',
                        style: GoogleFonts.spaceMono(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: FutureBuilder<DocumentSnapshot>(
                      // Cari tahu dulu domain Sensei ini
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .get(),
                      builder: (context, senseiSnapshot) {
                        if (senseiSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: purple),
                          );
                        }

                        // Ekstrak domainnya
                        String senseiDomain = '';
                        if (senseiSnapshot.hasData &&
                            senseiSnapshot.data!.exists) {
                          var data =
                              senseiSnapshot.data!.data()
                                  as Map<String, dynamic>;
                          senseiDomain = data['akademiDomain'] ?? '';
                        }

                        // Panggil riwayat yang khusus untuk domain ini
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('announcements')
                              .where(
                                'akademiDomain',
                                isEqualTo: senseiDomain,
                              ) // 👈 FILTER DOMAIN
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError)
                              return const Center(
                                child: Text('Terjadi kesalahan data.'),
                              );
                            if (snapshot.connectionState ==
                                ConnectionState.waiting)
                              return const Center(
                                child: CircularProgressIndicator(color: purple),
                              );

                            final docs = snapshot.data!.docs;

                            if (docs.isEmpty) {
                              return Center(
                                child: Text(
                                  'Belum ada pengumuman di LPK ini.',
                                  style: GoogleFonts.dmSans(color: Colors.grey),
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: docs.length,
                              itemBuilder: (context, index) {
                                final data =
                                    docs[index].data() as Map<String, dynamic>;
                                final message = data['message'] ?? '';
                                final timestamp =
                                    data['timestamp'] as Timestamp?;
                                final receivedCount =
                                    data['receivedCount'] ?? 0;
                                final readCount = data['readCount'] ?? 0;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              message,
                                              style: GoogleFonts.dmSans(
                                                fontSize: 13,
                                                color: const Color(0xFF1A1A2E),
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            _formatTime(timestamp),
                                            style: GoogleFonts.spaceMono(
                                              fontSize: 10,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: indigo.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              '✓ $receivedCount diterima',
                                              style: GoogleFonts.spaceMono(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: indigo,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: gold.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              '👁 $readCount dibaca',
                                              style: GoogleFonts.spaceMono(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: gold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
          ],
        ),
      ),
    );
  }
}
