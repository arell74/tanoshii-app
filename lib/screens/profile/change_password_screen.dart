import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Fungsi untuk memvalidasi dan mengubah password di Firebase
  Future<void> _changePassword() async {
    final String oldPass = _oldPasswordController.text.trim();
    final String newPass = _newPasswordController.text.trim();
    final String confirmPass = _confirmPasswordController.text.trim();

    // 1. Validasi Input Kosong
    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      _showError('Semua kolom harus diisi!');
      return;
    }

    // 2. Validasi Password Sama
    if (newPass != confirmPass) {
      _showError('Password baru dan konfirmasi tidak cocok!');
      return;
    }

    // 3. Validasi Panjang Password (minimal 6 karakter untuk Firebase)
    if (newPass.length < 6) {
      _showError('Password baru minimal 6 karakter!');
      return;
    }

    setState(() => _isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      
      if (user != null && user.email != null) {
        // 4. Proses Re-autentikasi (Cek apakah password lama benar)
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPass,
        );

        await user.reauthenticateWithCredential(credential);

        // 5. Jika password lama benar, ubah ke password baru
        await user.updatePassword(newPass);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password berhasil diubah!'),
              backgroundColor: Color(0xFF4A7C6F), // Warna Sage (Hijau sukses)
            ),
          );
          Navigator.pop(context); // Kembali ke halaman profil
        }
      }
    } on FirebaseAuthException catch (e) {
      // Menangkap error spesifik dari Firebase
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        _showError('Password lama yang Anda masukkan salah.');
      } else {
        _showError('Terjadi kesalahan: ${e.message}');
      }
    } catch (e) {
      _showError('Gagal mengubah password: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: const Color(0xFFD94F3D)), // Warna Vermillion (Merah error)
    );
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
        title: Text('Ubah Password', style: GoogleFonts.dmSans(color: ink, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: indigo))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pastikan password baru Anda sulit ditebak dan mudah diingat.',
                    style: GoogleFonts.dmSans(color: ink.withOpacity(0.6), fontSize: 14),
                  ),
                  const SizedBox(height: 32),

                  // Form Password Lama
                  _buildPasswordField('PASSWORD LAMA', _oldPasswordController, _obscureOld, () {
                    setState(() => _obscureOld = !_obscureOld);
                  }),
                  const SizedBox(height: 20),

                  // Form Password Baru
                  _buildPasswordField('PASSWORD BARU', _newPasswordController, _obscureNew, () {
                    setState(() => _obscureNew = !_obscureNew);
                  }),
                  const SizedBox(height: 20),

                  // Form Konfirmasi Password Baru
                  _buildPasswordField('KONFIRMASI PASSWORD BARU', _confirmPasswordController, _obscureConfirm, () {
                    setState(() => _obscureConfirm = !_obscureConfirm);
                  }),
                  const SizedBox(height: 40),

                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: indigo,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Simpan Password Baru', style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  // Widget bantuan (helper) untuk membuat form password agar kode tidak berulang
  Widget _buildPasswordField(String label, TextEditingController controller, bool isObscure, VoidCallback toggleObscure) {
    const Color ink = Color(0xFF1A1A2E);
    const Color indigo = Color(0xFF3D5A8A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold, color: ink.withOpacity(0.5))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscure, // Sensor password
          style: GoogleFonts.dmSans(color: ink, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ink.withOpacity(0.1))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ink.withOpacity(0.1))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: indigo)),
            // Tombol Mata untuk melihat/menyembunyikan password
            suffixIcon: IconButton(
              icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility, color: ink.withOpacity(0.4), size: 20),
              onPressed: toggleObscure,
            ),
          ),
        ),
      ],
    );
  }
}