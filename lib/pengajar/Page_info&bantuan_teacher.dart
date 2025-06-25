import 'package:flutter/material.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/headersmall_bar.dart';

void main() {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: InfoBantuanPage()),
  );
}

class InfoBantuanPage extends StatelessWidget {
  final List<FAQItem> faqItems = [
    FAQItem(
      title: "Tentang Aplikasi",
      content: "Ini adalah penjelasan tentang aplikasi.",
    ),
    FAQItem(
      title: "Cara Menambahkan Jadwal",
      content: "Panduan menambahkan jadwal dan jam pembelajaran.",
    ),
    FAQItem(
      title: "Cara Permintaan yang Disetujui",
      content: "Panduan permintaan yang disetujui.",
    ),
    FAQItem(
      title: "Pesanan Apa Saja yang Dapat Ditolak",
      content: "Beberapa alasan mengapa permintaan bisa ditolak.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSmallBar(
        title: 'Pengaturan',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: faqItems.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(faqItems[index].title),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(faqItems[index].content),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String title;
  final String content;

  FAQItem({required this.title, required this.content});
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
