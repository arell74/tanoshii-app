import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tanoshii_app/services/auth_service.dart';
import '../sensei/main_navigation.dart';
import '../siswa/main_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '../sensei_navigation.dart'; // Nanti kita buat file ini

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool isLogin = true;
  String selectedRole = 'Pelajar'; // Default role

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Fungsi untuk eksekusi login/register
  void _handleAuth() async {
    setState(() => _isLoading = true);
    try {
      if (isLogin) {
        // Proses Login
        User? user = await _authService.loginUser(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (user != null) {
          // Ambil role dari Firestore
          String role = await _authService.getUserRole(user.uid);
          _navigateBasedOnRole(role);
        }
      } else {
        // Proses Register
        await _authService.registerUser(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          selectedRole, // Mengambil nilai dari dropdown role
          _nameController.text.trim(),
        );
        _navigateBasedOnRole(selectedRole);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: ${e.toString()}")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateBasedOnRole(String role) {
    if (role.contains('Pelajar')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SenseiNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color vermillion = Color(0xFFD94F3D);
    const Color gold = Color(0xFFC9A84C);
    const Color paper = Color(0xFFFAF7F2);

    return Scaffold(
      backgroundColor: paper,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Logo & Title
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [vermillion, gold]),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  '語',
                  style: GoogleFonts.notoSerifJp(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isLogin ? 'Selamat Datang Kembali!' : 'Mulai Perjalananmu',
                style: GoogleFonts.dmSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ink,
                ),
              ),
              Text(
                isLogin
                    ? 'Masuk untuk melanjutkan progres belajarmu.'
                    : 'Buat akun untuk melacak progres belajar.',
                style: GoogleFonts.spaceMono(
                  fontSize: 12,
                  color: ink.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 40),

              // Role Selector (Dummy untuk presentasi)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ink.withOpacity(0.1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRole,
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: ink.withOpacity(0.5),
                    ),
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: ink,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue!;
                      });
                    },
                    items: <String>['Pelajar', 'Sensei (Pengajar)']
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text('Masuk sebagai: $value'),
                          );
                        })
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Form Inputs
              if (!isLogin)
                _buildTextField(
                  'Nama Lengkap',
                  Icons.person_outline,
                  ink,
                  controller: _nameController,
                ),
              if (!isLogin) const SizedBox(height: 16),
              _buildTextField(
                'Email',
                Icons.email_outlined,
                ink,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Password',
                Icons.lock_outline,
                ink,
                isPassword: true,
                controller: _passwordController,
              ),

              if (isLogin) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Lupa Password?',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: vermillion,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _handleAuth, // Panggil fungsi yang sudah kamu buat di atas!
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ink,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isLogin ? 'Masuk' : 'Daftar',
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Toggle Login/Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin ? 'Belum punya akun? ' : 'Sudah punya akun? ',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: ink.withOpacity(0.6),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin ? 'Daftar sekarang' : 'Masuk di sini',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: vermillion,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon,
    Color ink, {
    bool isPassword = false,
    required TextEditingController controller, // Tambahkan parameter ini
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ink.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller, // Pasang controller di sini
        obscureText: isPassword,
        style: GoogleFonts.dmSans(color: ink),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.dmSans(
            color: ink.withOpacity(0.4),
            fontSize: 14,
          ),
          prefixIcon: Icon(icon, color: ink.withOpacity(0.4), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
