import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'register_page.dart';
import 'package:aplikasi_lajuuu_learning/pengajar/halaman_utama.dart';

class LoginPageGuru extends StatelessWidget {
  const LoginPageGuru({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreenTeacher(),
    );
  }
}

class LoginScreenTeacher extends StatefulWidget {
  const LoginScreenTeacher({super.key});

  @override
  State<LoginScreenTeacher> createState() => _LoginScreenTeacherState();
}

class _LoginScreenTeacherState extends State<LoginScreenTeacher> {
  bool _isLoading = false;

  void _showTerms() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Ketentuan Penggunaan'),
            backgroundColor: Colors.white,
            content: const Text(
              'Dengan menggunakan aplikasi ini, Anda menyetujui ketentuan berikut:\n\n'
              '1. Akses Akun: Pengguna (siswa, guru, dan admin) wajib menjaga kerahasiaan informasi akun dan tidak membagikan data login kepada pihak lain.\n\n'
              '2. Penggunaan Aplikasi: Aplikasi ini hanya digunakan untuk keperluan pendidikan dan pembelajaran. Setiap penyalahgunaan aplikasi di luar tujuan tersebut akan dikenakan sanksi sesuai kebijakan sekolah atau pengembang.\n\n'
              '3. Hak Cipta: Seluruh materi pembelajaran, video, dan konten yang tersedia di aplikasi adalah milik pengembang atau pihak yang bekerja sama, dan tidak boleh disalin atau didistribusikan tanpa izin.\n\n'
              '4. Perubahan Layanan: Pengembang berhak untuk memperbarui, mengubah, atau menghentikan fitur aplikasi kapan saja dengan atau tanpa pemberitahuan sebelumnya.\n\n'
              '5. Tanggung Jawab: Pengguna bertanggung jawab atas semua aktivitas yang dilakukan melalui akun masing-masing.',
            ),
            actions: [
              TextButton(
                child: const Text('Oke'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  void _showPrivacy() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Kebijakan Privasi'),
            backgroundColor: Colors.white,
            content: const Text(
              'Aplikasi ini berkomitmen untuk melindungi privasi pengguna. Berikut adalah kebijakan kami:\n\n'
              '1. Pengumpulan Data: Kami mengumpulkan data seperti nama, alamat email, dan informasi terkait pengguna yang diperlukan untuk mendukung fungsi aplikasi dan keperluan penggunaan.\n\n'
              '2. Penggunaan Data:\n'
              '   • Mengelola akun pengguna sesuai peran mereka.\n'
              '   • Memberikan akses dan pengalaman yang sesuai dengan fitur yang tersedia.\n'
              '   • Meningkatkan kualitas, keamanan, dan performa aplikasi demi kenyamanan semua pengguna.\n\n'
              '3. Penyimpanan Data: Data disimpan dengan aman dan hanya dapat diakses oleh pihak yang berwenang.\n\n'
              '4. Pembagian Data: Kami tidak akan membagikan informasi pribadi pengguna kepada pihak ketiga tanpa persetujuan, kecuali jika diwajibkan oleh hukum.\n\n'
              '5. Keamanan Data: Kami menggunakan teknologi keamanan yang sesuai untuk melindungi data dari akses tidak sah, kehilangan, atau penyalahgunaan.\n\n'
              '6. Hak Pengguna: Pengguna dapat meminta akses, koreksi, atau penghapusan data pribadi melalui kontak resmi aplikasi.',
            ),
            actions: [
              TextButton(
                child: const Text('Oke'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final uid = userCredential.user!.uid;

      final doc =
          await FirebaseFirestore.instance
              .collection('pengajar')
              .doc(uid)
              .get();

      setState(() => _isLoading = false);

      if (doc.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePageTeacher()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login gagal: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          _isLoading
              ? const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Memproses...', style: TextStyle(fontSize: 18)),
                  ],
                ),
              )
              : SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Image.asset(
                              'assets/images/Logo Apk Lajuuu.png',
                              width: 250,
                              height: 250,
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Masuk Sebagai Pengajar',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Tombol login Google
                            GestureDetector(
                              onTap: _signInWithGoogle,
                              child: Container(
                                height: 70,
                                width: 310,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C4DFF),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.google,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 14),
                                    Text(
                                      'Masuk Dengan Google',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            const Text(
                              'Dengan masuk atau mendaftar, saya menyetujui',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: _showTerms,
                                  child: const Text(
                                    'Ketentuan Penggunaan Lajuuu Learning',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                const Text(
                                  ' dan ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                GestureDetector(
                                  onTap: _showPrivacy,
                                  child: const Text(
                                    'Kebijakan Privasi Lajuuu Learning',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}
