import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RekeningInputPage(),
    );
  }
}

class RekeningInputPage extends StatelessWidget {
  const RekeningInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    Color purpleColor = const Color(0xFF7C4DFF);
    Color customRed = const Color(0xFFe53935); // Merah serasi
    Color customGreen = const Color(0xFF43A047); // Hijau serasi

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: purpleColor,
            borderRadius: BorderRadius.circular(12),
          ),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Masukkan No Rekening Anda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              buildTextField('Masukkan nama'),
              const SizedBox(height: 10),
              buildTextField('Masukkan No Rek'),
              const SizedBox(height: 10),
              buildTextField('Masukkan Harga'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Aksi ketika tombol kembali ditekan
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customRed,
                      foregroundColor:
                          Colors.white, // <- ini buat tulisan jadi putih
                    ),
                    child: const Text('Kembali'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Aksi ketika tombol selesai ditekan
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customGreen,
                      foregroundColor:
                          Colors.white, // <- ini juga tulisan jadi putih
                    ),
                    child: const Text('Selesai'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
