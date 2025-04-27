import 'package:flutter/material.dart';
import 'halaman_pesanan.dart';
import 'halaman_chat.dart'; // Pastikan file ini sudah diimpor

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFF7C4DFF),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        // Logika navigasi sesuai indeks tombol
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HalamanPesanan()),
          );
        } else if (index == 2) {
          // Untuk tombol "Chat"
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatListPage(),
            ), // Navigasi ke ChatListPage
          );
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Pesanan'),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ), // Tombol "Chat"
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
      ],
    );
  }
}
