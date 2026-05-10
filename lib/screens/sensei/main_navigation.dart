import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tanoshii_app/screens/sensei/announcement/announcement_screen.dart';
import 'package:tanoshii_app/screens/sensei/kelas/student_monitor.dart';
import 'package:tanoshii_app/screens/sensei/sensei_profile/profile_screen.dart';
import 'package:tanoshii_app/screens/sensei/quiz/quiz_management_screen.dart';
import 'home/home_screen.dart';

class SenseiNavigation extends StatefulWidget {
  const SenseiNavigation({Key? key}) : super(key: key);

  @override
  State<SenseiNavigation> createState() => _SenseiNavigationState();
}

class _SenseiNavigationState extends State<SenseiNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const SenseiHomeScreen(),
    const StudentMonitorScreen(),
    const QuizManagementScreen(),
    const AnnouncementScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color indigo = Color(0xFF3D5A8A);

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: indigo,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        selectedLabelStyle: GoogleFonts.spaceMono(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.spaceMono(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'KELAS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_rounded),
            label: 'KUIS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign_rounded),
            label: 'NOTIF',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'SETING',
          ),
        ],
      ),
    );
  }
}
