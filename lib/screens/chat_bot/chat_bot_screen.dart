import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _AiSenseiScreenState();
}

class _AiSenseiScreenState extends State<ChatBotScreen> {
  final TextEditingController _chatController = TextEditingController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);
    const Color indigo = Color(0xFF3D5A8A);
    const Color bgColor = Color(0xFFF4F1EC); // Sesuai warna background s-ai

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ── HEADER SECTION ──
          Container(
            padding: const EdgeInsets.fromLTRB(18, 50, 18, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2A1A3E), Color(0xFF3D2050)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                // Avatar AI
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [gold, vermillion], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: gold.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))
                    ],
                  ),
                  alignment: Alignment.center,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/raii.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info Header
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Raiden AI', style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('先生 · AI BAHASA JEPANG', style: GoogleFonts.spaceMono(color: Colors.white.withOpacity(0.5), fontSize: 10, letterSpacing: 1)),
                    ],
                  ),
                ),
                // Online Indicator
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ADE80), // Green light
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF4ADE80).withOpacity(0.6), blurRadius: 6)
                    ],
                  ),
                )
              ],
            ),
          ),

          // ── CHAT BODY SECTION ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Date separator
                Center(
                  child: Text('HARI INI, 02:40', style: GoogleFonts.spaceMono(fontSize: 10, color: ink.withOpacity(0.3), letterSpacing: 1)),
                ),
                const SizedBox(height: 16),

                // AI Chat Bubble 1
                _buildChatBubble(
                  isUser: false,
                  avatarLabel: '先',
                  time: '09:40',
                  child: Text.rich(
                    TextSpan(
                      style: GoogleFonts.dmSans(fontSize: 13, color: ink, height: 1.5),
                      children: const [
                        TextSpan(text: 'おはようございます！ Selamat pagi rell! Hari ini kita akan belajar apa? Kamu bisa tanya apa saja tentang aksara atau bahasa Jepang 😊'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // User Chat Bubble
                _buildChatBubble(
                  isUser: true,
                  avatarLabel: 'F',
                  time: '02:41',
                  child: Text.rich(
                    TextSpan(
                      style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white, height: 1.5),
                      children: [
                        const TextSpan(text: 'Sensei, apa bedanya '),
                        TextSpan(text: 'は', style: GoogleFonts.notoSerifJp(color: const Color(0xFFE8CC7E), fontSize: 16, fontWeight: FontWeight.bold)), // goldLight
                        const TextSpan(text: ' dan '),
                        TextSpan(text: 'わ', style: GoogleFonts.notoSerifJp(color: const Color(0xFFE8CC7E), fontSize: 16, fontWeight: FontWeight.bold)),
                        const TextSpan(text: '?'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // AI Chat Bubble 2
                _buildChatBubble(
                  isUser: false,
                  avatarLabel: '先',
                  time: '02:41',
                  child: Text.rich(
                    TextSpan(
                      style: GoogleFonts.dmSans(fontSize: 13, color: ink, height: 1.5),
                      children: [
                        const TextSpan(text: 'Pertanyaan bagus! '),
                        TextSpan(text: 'は (ha)', style: GoogleFonts.notoSerifJp(color: vermillion, fontSize: 15, fontWeight: FontWeight.bold)),
                        const TextSpan(text: ' adalah konsonan biasa, tapi kalau jadi partikel topik, dibacanya '),
                        const TextSpan(text: '"wa"', style: TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(text: '. Contoh: 私'),
                        TextSpan(text: 'は', style: GoogleFonts.notoSerifJp(color: vermillion, fontSize: 15, fontWeight: FontWeight.bold)),
                        const TextSpan(text: '学生 (Watashi '),
                        const TextSpan(text: 'wa', style: TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(text: ' gakusei). Sementara '),
                        TextSpan(text: 'わ (wa)', style: GoogleFonts.notoSerifJp(color: vermillion, fontSize: 15, fontWeight: FontWeight.bold)),
                        const TextSpan(text: ' hanya dipakai untuk kata biasa.'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Chips Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildQuickChip('Contoh kalimat', ink),
                      const SizedBox(width: 8),
                      _buildQuickChip('Latihan soal', ink),
                      const SizedBox(width: 8),
                      _buildQuickChip('Jelaskan lagi', ink),
                      const SizedBox(width: 8),
                      _buildQuickChip('Raiden lagi apa?', ink),
                    ],
                  ),
                )
              ],
            ),
          ),

          // ── INPUT BAR SECTION ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: ink.withOpacity(0.06))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: ink.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _chatController,
                      style: GoogleFonts.dmSans(fontSize: 13, color: ink),
                      decoration: InputDecoration(
                        hintText: 'Tanya Sensei...',
                        hintStyle: GoogleFonts.dmSans(fontSize: 13, color: ink.withOpacity(0.4)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [vermillion, const Color(0xFFB03828)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    onPressed: () {
                      // TODO: Implement send message logic
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Helper Widget: Chat Bubble
  Widget _buildChatBubble({
    required bool isUser,
    required String avatarLabel,
    required String time,
    required Widget child,
  }) {
    const Color ink = Color(0xFF1A1A2E);
    const Color indigo = Color(0xFF3D5A8A);
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);

    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isUser) ...[
          // AI Avatar Smal
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              // Hapus gradient jika ingin gambar full
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/raii.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        
        Flexible(
          child: Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isUser ? indigo : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                    bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                  ),
                  boxShadow: isUser ? [] : [
                    BoxShadow(color: ink.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                  ],
                ),
                child: child,
              ),
              const SizedBox(height: 4),
              Text(time, style: GoogleFonts.spaceMono(fontSize: 9, color: ink.withOpacity(0.3))),
            ],
          ),
        ),

        if (isUser) ...[
          const SizedBox(width: 8),
          // User Avatar Small
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: indigo,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(avatarLabel, style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ],
    );
  }

  // Helper Widget: Quick Chip
  Widget _buildQuickChip(String label, Color ink) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: ink.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: ink.withOpacity(0.02), blurRadius: 2, offset: const Offset(0, 1))
        ],
      ),
      child: Text(label, style: GoogleFonts.dmSans(fontSize: 11, color: ink, fontWeight: FontWeight.bold)),
    );
  }
}