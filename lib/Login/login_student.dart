import 'package:aplikasi_lajuuu_learning/service/firebase_auth_service.dart';
import 'package:aplikasi_lajuuu_learning/Login/login_teacher.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/halaman_utama.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPageStudent extends StatelessWidget {
  const LoginPageStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreenStudent(),
    );
  }
}

class LoginScreenStudent extends StatefulWidget {
  const LoginScreenStudent({super.key});

  @override
  State<LoginScreenStudent> createState() => _LoginScreenStudentState();
}

class _LoginScreenStudentState extends State<LoginScreenStudent> {
  bool _isLoading = false;

  Future<void> _loginGoogle() async {
    setState(() => _isLoading = true);

    try {
      await FirebaseAuthService().signInWithGoogle();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal login: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
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
          (_) => AlertDialog(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          _isLoading
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Memproses...', style: TextStyle(fontSize: 18)),
                  ],
                ),
              )
              : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Image.asset(
                            'assets/images/Logo Apk Lajuuu.png',
                            width: 250,
                            height: 250,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Tombol Masuk Google
                        GestureDetector(
                          onTap: _loginGoogle,
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

                        const SizedBox(height: 16),

                        // Tambahkan link daftar sebagai pengajar
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(fontSize: 16.0),
                            children: [
                              const TextSpan(
                                text:
                                    'Yuk, berbagi ilmu! Daftar jadi pengajar ',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: 'klik di sini',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => const LoginPageGuru(),
                                          ),
                                        );
                                      },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),
                        Column(
                          children: [
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
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
