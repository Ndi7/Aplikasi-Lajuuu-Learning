import 'package:flutter/material.dart';
import 'halaman_utama.dart';
import 'halaman_pesanan.dart';
import 'halaman_chat.dart';

// bottom_bar.dart
class BottomBar extends StatelessWidget {
  final bool showBottomBar;
  final bool disableHighlight;
  const BottomBar({
    Key? key,
    required this.showBottomBar,
    this.disableHighlight = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showBottomBar) return SizedBox.shrink();

    final Color selectedColor =
        disableHighlight ? Colors.grey : const Color(0xFF7C4DFF);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: selectedColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HalamanPesanan()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChatListPage()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Pesanan'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
      ],
    );
  }
}
