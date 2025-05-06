import 'package:flutter/material.dart';

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
    if (!showBottomBar) return const SizedBox.shrink();

    final Color selectedColor =
        disableHighlight ? Colors.grey : const Color(0xFF7C4DFF);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: selectedColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        // switch (index) {
        //   case 0:
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(builder: (_) => const HomeScreen()),
        //     );
        //     break;
        //   case 1:
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (_) => const HalamanPesanan()),
        //     );
        //     break;
        //   case 2:
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (_) => const ChatListPage()),
        //     );
        //     break;
        //   default:
        //     break;
        // }
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
