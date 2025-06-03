// Tetap gunakan import yang sama
import 'package:flutter/material.dart';
import 'package:aplikasi_lajuuu_learning/Login/register_page.dart';
import 'package:aplikasi_lajuuu_learning/pengajar/halaman_utama.dart';

void main() {
  runApp(const LoginPageGuru());
}

class LoginPageGuru extends StatefulWidget {
  const LoginPageGuru({super.key});

  @override
  State<LoginPageGuru> createState() => _MyAppState();
}

class _MyAppState extends State<LoginPageGuru> {
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
  final TextEditingController _emailController = TextEditingController();

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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // Email field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),

                const SizedBox(height: 24),

                // Tombol Masuk
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      debugPrint("Email: ${_emailController.text}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Content()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C4DFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Daftar di sini',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
