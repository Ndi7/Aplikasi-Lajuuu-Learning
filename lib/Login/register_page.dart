import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aplikasi_lajuuu_learning/pengajar/halaman_utama.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _universityController = TextEditingController();
  final _contacNumberController = TextEditingController();
  final _kategoriLainnyaController = TextEditingController();
  final _sertifikatLinkController = TextEditingController();

  String? _kategoriDipilih;
  bool _showKategoriLainnya = false;

  final List<String> _kategoriList = [
    'Pemrograman Dasar',
    'Rekayasa Mobile',
    'Bahasa Pemrograman Linux',
    'Desain UI/UX',
    'Python',
    'C++',
    'Javascript',
    'HTML dan CSS',
    'Lainnya',
  ];

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[200],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7C4DFF), width: 2),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ditemukan akun Google')),
          );
          return;
        }

        final selectedCategory =
            _kategoriDipilih == 'Lainnya'
                ? _kategoriLainnyaController.text.trim()
                : _kategoriDipilih;

        final pengajarRef = FirebaseFirestore.instance
            .collection('pengajar')
            .doc(user.uid);

        final data = {
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'university': _universityController.text.trim(),
          'contacNumber': _contacNumberController.text.trim(),
          'category': selectedCategory,
          'sertificationUrl': _sertifikatLinkController.text.trim(),
          'role': 'pengajar',
          'createdAt': FieldValue.serverTimestamp(),
        };

        await pengajarRef.set(data);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(data);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Pendaftaran berhasil')));

        _formKey.currentState!.reset();
        setState(() {
          _kategoriDipilih = null;
          _showKategoriLainnya = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePageTeacher()),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mendaftar: $e')));
      }
    }
  }

  @override
  void dispose() {
    _universityController.dispose();
    _contacNumberController.dispose();
    _kategoriLainnyaController.dispose();
    _sertifikatLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset('assets/images/Logo Apk Lajuuu.png', height: 200),
                const Text(
                  'Daftar Pengajar',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (user != null) ...[
                  Text(
                    "Nama: ${user.displayName}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Email: ${user.email}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _contacNumberController,
                  decoration: _inputDecoration('Nomor Telepon'),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _universityController,
                  decoration: _inputDecoration('Universitas'),
                  validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _kategoriDipilih,
                  decoration: _inputDecoration('Kategori Materi'),
                  items:
                      _kategoriList
                          .map(
                            (kategori) => DropdownMenuItem(
                              value: kategori,
                              child: Text(kategori),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _kategoriDipilih = value;
                      _showKategoriLainnya = value == 'Lainnya';
                    });
                  },
                  validator: (value) => value == null ? 'Pilih kategori' : null,
                ),
                if (_showKategoriLainnya)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: TextFormField(
                      controller: _kategoriLainnyaController,
                      decoration: _inputDecoration('Tulis Kategori Lainnya'),
                      validator:
                          (value) =>
                              _showKategoriLainnya && value!.isEmpty
                                  ? 'Wajib diisi'
                                  : null,
                    ),
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _sertifikatLinkController,
                  decoration: _inputDecoration(
                    'Link Sertifikat (contoh: Google Drive PDF)',
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Wajib isi link sertifikat'
                              : null,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C4DFF),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
