import 'package:flutter/material.dart';
import 'package:aplikasi_lajuuu_learning/pengajar/bottom_bar_teacher.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/headersmall_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DaftarPesananPage(),
    );
  }
}

class DaftarPesananPage extends StatefulWidget {
  @override
  _DaftarPesananPageState createState() => _DaftarPesananPageState();
}

class _DaftarPesananPageState extends State<DaftarPesananPage> {
  bool _expanded = false;

  final Map<String, dynamic> pesanan = {
    'nama': 'Lajuuu',
    'matakuliah': 'Pemrograman Dasar',
    'metode': 'Online',
    'waktu': '16.00 - 17.00',
    'total': 50000,
    'status': 'Sudah Dibayar',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSmallBar(
        title: 'Pesanan',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      bottomNavigationBar: const BottomBarTeacher(
        showBottomBar: true,
        currentIndex: 1,
        disableHighlight: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage("assets/avatar.png"),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                pesanan['nama'],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Icon(
                              _expanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_expanded)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Detail Pemesanan",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              "Matakuliah",
                              pesanan['matakuliah'],
                            ),
                            _buildDetailRow("Metode", pesanan['metode']),
                            _buildDetailRow("Waktu", pesanan['waktu']),
                            const Divider(height: 24),
                            Text.rich(
                              TextSpan(
                                text: "Total : ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Rp ${pesanan['total']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "(${pesanan['status']})",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  child: const Text(
                                    "TOLAK",
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                  ),
                                  child: const Text(
                                    "TERIMA",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value)],
      ),
    );
  }
}
