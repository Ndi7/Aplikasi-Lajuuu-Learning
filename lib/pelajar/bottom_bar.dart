import 'package:flutter/material.dart';
import 'halaman_utama.dart';
import 'halaman_pesanan.dart';
import 'halaman_chat.dart';
import 'ProfilPelajar.dart';

class BottomBar extends StatelessWidget {
  final bool showBottomBar;
  final bool disableHighlight;

  /// Tambahan: index halaman saat ini
  final int currentIndex;

  const BottomBar({
    Key? key,
    required this.showBottomBar,
    this.disableHighlight = false,
    this.currentIndex = 0, // default ke halaman pertama (Beranda)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showBottomBar) return const SizedBox.shrink();

    final Color selectedColor =
        disableHighlight ? Colors.grey : const Color(0xFF7C4DFF);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex, // ← Gunakan index yang diberikan
      selectedItemColor: selectedColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == currentIndex) return; // Jangan pindah kalau halaman sama

        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HalamanPesanan()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ChatListPage()),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'Pesanan',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
      ],
    );
  }
}
