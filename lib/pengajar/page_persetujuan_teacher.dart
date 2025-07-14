import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_lajuuu_learning/pengajar/bottom_bar_teacher.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/headersmall_bar.dart';
import 'dart:convert';
import 'dart:typed_data';

class DaftarPesananPage extends StatefulWidget {
  @override
  _DaftarPesananPageState createState() => _DaftarPesananPageState();
}

class _DaftarPesananPageState extends State<DaftarPesananPage> {
  Map<String, bool> expandStatus = {};
  String? _selectedStatus;

  Future<void> updateStatus(String docId, String status) async {
    await FirebaseFirestore.instance
        .collection('ajukan_jadwal')
        .doc(docId)
        .update({'status': status});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Pesanan telah $status')));
  }

  void showBuktiPembayaran(BuildContext context, String? base64Image) {
    if (base64Image == null || base64Image.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bukti pembayaran tidak tersedia')),
      );
      return;
    }

    Uint8List bytes = base64Decode(base64Image);

    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.memory(bytes, fit: BoxFit.contain),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final pengajarId = currentUser?.uid ?? '';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton<String>(
                onSelected: (String value) {
                  setState(() {
                    _selectedStatus = value == 'Semua' ? null : value;
                  });
                },
                itemBuilder:
                    (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'Diterima',
                        child: Text('Diterima'),
                      ),
                      const PopupMenuItem(
                        value: 'Ditolak',
                        child: Text('Ditolak'),
                      ),
                      const PopupMenuItem(
                        value: 'Menunggu Konfirmasi',
                        child: Text('Menunggu Konfirmasi'),
                      ),
                      const PopupMenuItem(
                        value: 'Semua',
                        child: Text('Tampilkan Semua'),
                      ),
                    ],
                icon: const Icon(Icons.more_vert),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('ajukan_jadwal')
                        .where('pengajarId', isEqualTo: pengajarId)
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Belum ada pesanan.'));
                  }

                  final allPesanan = snapshot.data!.docs;

                  final pesananList =
                      _selectedStatus == null
                          ? allPesanan
                          : allPesanan.where((doc) {
                            final status =
                                (doc.data()
                                    as Map<String, dynamic>)['status'] ??
                                '';
                            return status == _selectedStatus;
                          }).toList();

                  if (pesananList.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada pesanan dengan status ini.'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: pesananList.length,
                    itemBuilder: (context, index) {
                      final doc = pesananList[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final docId = doc.id;
                      final isExpanded = expandStatus[docId] ?? false;

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                expandStatus[docId] = !isExpanded;
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
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage: _buildPhotoPelajar(
                                      data['photoPelajar'],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      data['nama_pengajar'] ?? '-',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isExpanded)
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildDetailRow(
                                    "Matakuliah",
                                    data['mata_kuliah'] ?? '-',
                                  ),
                                  _buildDetailRow(
                                    "Metode",
                                    data['metode'] ?? '-',
                                  ),
                                  _buildDetailRow(
                                    "Tanggal",
                                    data['tanggal'] ?? '-',
                                  ),
                                  _buildDetailRow(
                                    "Waktu",
                                    data['waktu'] ?? '-',
                                  ),
                                  const Divider(height: 24),
                                  GestureDetector(
                                    onTap: () {
                                      showBuktiPembayaran(
                                        context,
                                        data['bukti_pembayaran_base64'],
                                      );
                                    },
                                    child: const Text(
                                      'Lihat Bukti Pembayaran',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "(${data['status'] ?? 'Pending'})",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const Divider(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (data['status'] ==
                                              'Menunggu Konfirmasi' ||
                                          data['status'] == null) ...[
                                        OutlinedButton(
                                          onPressed: () {
                                            updateStatus(docId, 'Ditolak');
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                          child: const Text(
                                            "TOLAK",
                                            style: TextStyle(
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            updateStatus(docId, 'Diterima');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                          ),
                                          child: const Text(
                                            "TERIMA",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ] else
                                        Text(
                                          'Pesanan ${data['status']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  );
                },
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

ImageProvider _buildPhotoPelajar(String? photoPath) {
  if (photoPath == null || photoPath.isEmpty) {
    // Tidak ada foto → gunakan gambar default
    return const AssetImage('assets/images/profile.png');
  }
  final file = File(photoPath);
  if (file.existsSync()) {
    // Jika path lokal dan file ada
    return FileImage(file);
  } else {
    // Jika path lokal tapi file tidak ada
    return const AssetImage('assets/images/profile.png');
  }
}
