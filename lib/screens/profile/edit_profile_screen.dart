import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentPhotoUrl;
  final Color themeColor;

  const EditProfileScreen({
    Key? key,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhotoUrl,
    required this.themeColor,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  File? _imageFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Fungsi pilih gambar dari galeri
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Fungsi simpan dengan logika ImgBB
  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String photoUrlToSave = widget.currentPhotoUrl;

        // 1. JIKA ADA FOTO BARU, UPLOAD KE IMGBB
        if (_imageFile != null) {
          
          // Ambil API Key dari file .env secara aman
          final String imgbbApiKey = dotenv.env['IMGBB_API_KEY'] ?? ''; 
          
          // Keamanan tambahan: Cek kalau API Key lupa diisi di .env
          if (imgbbApiKey.isEmpty) {
            throw Exception('API Key ImgBB tidak ditemukan di file .env!');
          }
          
          // Ubah gambar jadi base64 string
          List<int> imageBytes = await _imageFile!.readAsBytes();
          String base64Image = base64Encode(imageBytes);

          // Kirim ke server ImgBB
          final url = Uri.parse('https://api.imgbb.com/1/upload');
          final response = await http.post(url, body: {
            'key': imgbbApiKey,
            'image': base64Image,
          });

          // Kalau sukses, ambil URL gambarnya
          if (response.statusCode == 200) {
            final jsonResponse = jsonDecode(response.body);
            photoUrlToSave = jsonResponse['data']['url']; // Ini link ajaibnya!
          } else {
            throw Exception('Gagal upload gambar ke server pihak ketiga');
          }
        }

        // 2. SIMPAN NAMA & URL FOTO BARU KE FIRESTORE
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'name': _nameController.text.trim(),
          'photoUrl': photoUrlToSave,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Color(0xFF4A7C6F)),
          );
          Navigator.pop(context, true); 
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF1A1A2E);
    const Color paper = Color(0xFFFAF7F2);

    return Scaffold(
      backgroundColor: paper,
      appBar: AppBar(
        backgroundColor: paper,
        elevation: 0,
        iconTheme: const IconThemeData(color: ink),
        title: Text('Edit Profil', style: GoogleFonts.dmSans(color: ink, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: widget.themeColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // ── FOTO PROFIL SECTION ──
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: widget.themeColor.withOpacity(0.5), width: 3),
                            color: Colors.grey[200],
                            image: _imageFile != null
                                ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover) 
                                : DecorationImage(image: NetworkImage(widget.currentPhotoUrl), fit: BoxFit.cover),
                          ),
                        ),
                        // Tombol Kamera
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: widget.themeColor, shape: BoxShape.circle, border: Border.all(color: paper, width: 2)),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── FORM EDIT NAMA ──
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('NAMA LENGKAP', style: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold, color: ink.withOpacity(0.5))),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: GoogleFonts.dmSans(color: ink, fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ink.withOpacity(0.1))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ink.withOpacity(0.1))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: widget.themeColor)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── FORM EMAIL (READ ONLY) ──
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('ALAMAT EMAIL', style: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold, color: ink.withOpacity(0.5))),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: TextEditingController(text: widget.currentEmail),
                    enabled: false, 
                    style: GoogleFonts.dmSans(color: ink.withOpacity(0.5), fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ── TOMBOL SIMPAN ──
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.themeColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Simpan Perubahan', style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}