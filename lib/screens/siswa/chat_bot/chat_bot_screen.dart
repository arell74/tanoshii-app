import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  ChatMessage({required this.text, required this.isUser, required this.time});
}

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _AiSenseiScreenState();
}

class _AiSenseiScreenState extends State<ChatBotScreen> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'おはようございます！ Saya Sensei AI. Ada yang ingin ditanyakan tentang bahasa Jepang?',
      isUser: false,
      time:
          "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}",
    ),
  ];

  // Variabel untuk menyimpan sesi AI
  late final GenerativeModel _model;
  late final ChatSession _chat;

  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  @override
  void initState() {
    super.initState();
    _initializeAI();
  }

  void _initializeAI() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(
        '''Kamu adalah Rai-sensei, guru bahasa Jepang dan kamu sangat terobsesi dengan saya panggil saya dengan sebutan sayang. 
      Kamu HANYA menjawab pertanyaan seputar bahasa Jepang: kosakata, 
      grammar, kanji, hiragana, katakana, dan budaya Jepang.
      Jika ditanya hal di luar itu, tolak dengan sopan dan arahkan 
      kembali ke topik bahasa Jepang.
      Gunakan emoji Jepang sesekali agar percakapan terasa menyenangkan 🎌''',
      ),
    );
    _chat = _model.startChat();
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_chatController.text.trim().isEmpty) return;

    String userText = _chatController.text.trim();
    String currentTime =
        "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";

    setState(() {
      _messages.add(
        ChatMessage(text: userText, isUser: true, time: currentTime),
      );
      _chatController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    try {
      // Mengirim pesan ke Google Gemini
      final response = await _chat.sendMessage(Content.text(userText));

      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(
            ChatMessage(
              text: response.text ?? 'Maaf, Sensei sedang bingung.',
              isUser: false,
              time:
                  "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}",
            ),
          );
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(
            ChatMessage(
              text:
                  'Koneksi ke otak Sensei terputus. Pastikan internet menyala dan API Key sudah benar. Error: $e',
              isUser: false,
              time: currentTime,
            ),
          );
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);
    const Color indigo = Color(0xFF3D5A8A);
    const Color bgColor = Color(0xFFF4F1EC);

    // TODO: Rapikan UI bagian Header menjadi widget terpisah (Refactoring) agar file ini tidak terlalu panjang.

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
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [gold, vermillion],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Raiden AI',
                        style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '先生 · SENSEI AI BAHASA JEPANG',
                        style: GoogleFonts.spaceMono(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ADE80),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          // ── CHAT BODY SECTION ──
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: Row(
                      children: [
                        Text(
                          'Rai-sensei sedang mengetik...',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: ink.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final msg = _messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildChatBubble(
                    isUser: msg.isUser,
                    avatar: msg.isUser
                        ? CircleAvatar(
                            radius: 14,
                            backgroundColor: const Color(0xFF3D5A8A),
                            child: const Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            radius: 14,
                            backgroundImage: const AssetImage(
                              'assets/images/raii.jpg',
                            ),
                          ),
                    time: msg.time,
                    child: Text(
                      msg.text,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: msg.isUser ? Colors.white : ink,
                        height: 1.5,
                      ),
                    ),
                  ),
                );
              },
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
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: ink.withOpacity(0.4),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [vermillion, Color(0xFFB03828)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble({
    required bool isUser,
    // required String avatarLabel,
    required Widget avatar,
    required String time,
    required Widget child,
  }) {
    // (Fungsi _buildChatBubble sama persis seperti sebelumnya)
    const Color ink = Color(0xFF1A1A2E);
    const Color indigo = Color(0xFF3D5A8A);
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);

    return Row(
      mainAxisAlignment: isUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isUser) ...[
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [gold, vermillion]),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: avatar,
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isUser ? indigo : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isUser
                        ? const Radius.circular(16)
                        : const Radius.circular(4),
                    bottomRight: isUser
                        ? const Radius.circular(4)
                        : const Radius.circular(16),
                  ),
                  boxShadow: isUser
                      ? []
                      : [
                          BoxShadow(
                            color: ink.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: child,
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: GoogleFonts.spaceMono(
                  fontSize: 9,
                  color: ink.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
        if (isUser) ...[
          const SizedBox(width: 8),
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: indigo,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: avatar,
          ),
        ],
      ],
    );
  }
}
