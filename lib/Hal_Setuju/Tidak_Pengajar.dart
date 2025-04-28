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
      home: const ConfirmationPage(),
    );
  }
}

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Color purpleColor = const Color(0xFF7C4DFF);
    Color customRed = const Color(0xFFe53935); // Warna merah TIDAK
    Color customGreen = const Color(0xFF43A047); // Warna hijau IYA

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
                'Jadwal akan disimpan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Apa anda yakin menyimpannya??',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Aksi jika klik TIDAK
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customRed,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(100, 40),
                    ),
                    child: const Text('TIDAK'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Aksi jika klik IYA
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customGreen,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(100, 40),
                    ),
                    child: const Text('IYA'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
