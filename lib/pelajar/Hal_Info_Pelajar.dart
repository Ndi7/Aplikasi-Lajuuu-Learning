import 'package:flutter/material.dart';
import 'headersmall_bar.dart';

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
      title: "Cara memilih pengajar",
      content: "Panduan untuk memilih pengajar yang sesuai.",
    ),
    FAQItem(
      title: "Cara melakukan pembayaran",
      content: "Langkah-langkah untuk melakukan pembayaran.",
    ),
    FAQItem(
      title: "Mengapa permintaan ditolak",
      content: "Beberapa alasan mengapa permintaan bisa ditolak.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSmallBar(
        title: 'Info & Bantuan',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          ClipPath(
            clipper: CustomAppBarClipper(),
            child: Container(
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Info & Bantuan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Ukuran font sedikit lebih besar
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
