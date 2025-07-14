import 'package:flutter/material.dart';
import 'package:aplikasi_lajuuu_learning/pengajar/halaman_utama.dart';
import 'Profile_pengajar.dart';
import 'package:aplikasi_lajuuu_learning/pengajar/halaman_chat.dart';
import 'package:aplikasi_lajuuu_learning/pengajar/page_persetujuan_teacher.dart';

class BottomBarTeacher extends StatelessWidget {
  final bool showBottomBar;
  final bool disableHighlight;
  final int currentIndex;

  const BottomBarTeacher({
    Key? key,
    required this.showBottomBar,
    this.disableHighlight = false,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showBottomBar) return const SizedBox.shrink();

    final Color selectedColor =
        disableHighlight ? Colors.grey : const Color(0xFF7C4DFF);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: selectedColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePageTeacher()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => DaftarPesananPage()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HalamanChat()),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreenTeacher()),
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
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Pesan'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
      ],
    );
  }
}
