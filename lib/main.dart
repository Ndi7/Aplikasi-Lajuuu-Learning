import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Header dengan bentuk khusus
          ClipPath(
            clipper: HeaderClipper(),
            child: Container(
              height: 200,
              color: Color(0xFF7C4DFF), // Warna header
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hi, Lajuuu',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Mau belajar apa hari ini?',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Tombol di tengah sudut segitiga
          Positioned(
            top: 160, // Atur posisi vertikal tombol
            left: MediaQuery.of(context).size.width / 2 - 80, // Atur agar tombol berada di tengah
            child: ElevatedButton(
              onPressed: () {
                // Aksi ketika tombol ditekan
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF7C4DFF), // Warna tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 5,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text('CARI GURUMU'),
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF7C4DFF), // Warna ikon terpilih
        unselectedItemColor: Colors.grey, // Warna ikon tidak terpilih
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}

// Custom Clipper untuk header
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 20.0; // Radius sudut bawah

    final path = Path();
    // Garis ke bawah kiri sebelum radius
    path.lineTo(0, size.height - 50 - radius);

    // Kurva sudut kiri
    path.quadraticBezierTo(
      0, size.height - 50, // Kontrol untuk sudut kiri
      radius, size.height - 45, // Titik akhir kurva sudut kiri
    );

    // Garis ke titik segitiga di tengah
    path.lineTo(size.width / 2, size.height);

    // Garis dari titik segitiga ke kanan sebelum radius
    path.lineTo(size.width - radius, size.height - 50);

    // Kurva sudut kanan
    path.quadraticBezierTo(
      size.width, size.height - 55, // Kontrol untuk sudut kanan
      size.width, size.height - 55 - radius, // Titik akhir kurva sudut kanan
    );

    // Garis ke atas kanan
    path.lineTo(size.width, 0);

    // Menutup path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}