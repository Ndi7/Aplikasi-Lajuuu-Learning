import 'package:flutter/material.dart';

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 160,
      left: MediaQuery.of(context).size.width / 2 - 80,
      child: ElevatedButton(
        onPressed: () {
          // Aksi ketika tombol ditekan
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF7C4DFF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 5,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text('CARI GURUMU'),
        ),
      ),
    );
  }
}
