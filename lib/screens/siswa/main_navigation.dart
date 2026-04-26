import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tanoshii_app/screens/siswa/progress/progress_screen.dart';
import 'chat_bot/chat_bot_screen.dart';
import 'flashcard/flashcard_screen.dart';
import 'quiz/quiz_screen.dart';
import 'home/home_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),
      
      FlashcardScreen(
        onBack: () {
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),
      const QuizScreen(),
      const ChatBotScreen(),
      const ProgressScreen( ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFD94F3D), // Vermillion
        unselectedItemColor: Colors.grey.withOpacity(0.6),
        selectedLabelStyle: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.spaceMono(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'BELAJAR'),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline_rounded), label: 'KUIS'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy_outlined), label: 'SENSEI'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'PROGRES'),
        ],
      ),
    );
  }
}