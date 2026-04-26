import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tanoshii_app/screens/sensei/profile/profile_screen.dart';
import './home/home_screen.dart';

class SenseiNavigation extends StatefulWidget {
  const SenseiNavigation({Key? key}) : super(key: key);

  @override
  State<SenseiNavigation> createState() => _SenseiNavigationState();
}

class _SenseiNavigationState extends State<SenseiNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const SenseiHomeScreen(),
    const Center(child: Text('Daftar Murid Lengkap')),
    const Center(child: Text('Manajemen Kurikulum')),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFC9A84C), // Gold untuk Sensei
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        selectedLabelStyle: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.spaceMono(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'OVERVIEW'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt_rounded), label: 'MURID'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note_rounded), label: 'KONTEN'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'OPSI'),
        ],
      ),
    );
  }
}