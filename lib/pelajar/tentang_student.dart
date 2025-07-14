import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:aplikasi_lajuuu_learning/pelajar/ulasan_student.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/jadwal_student.dart';
import 'package:aplikasi_lajuuu_learning/widget/headersmall_bar.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/bottom_bar.dart';

class TentangPengajar extends StatelessWidget {
  final String pengajarId;
  const TentangPengajar({Key? key, required this.pengajarId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ProfileScreenPengajar(pengajarId: pengajarId),
    );
  }
}

class ProfileScreenPengajar extends StatefulWidget {
  final String pengajarId;
  const ProfileScreenPengajar({Key? key, required this.pengajarId})
    : super(key: key);

  @override
  State<ProfileScreenPengajar> createState() => _ProfileScreenPengajarState();
}

class _ProfileScreenPengajarState extends State<ProfileScreenPengajar> {
  int _selectedIndex = 1;
  Map<String, dynamic>? pengajarData;

  @override
  void initState() {
    super.initState();
    _loadPengajar();
  }

  Future<void> _loadPengajar() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('pengajar')
              .doc(widget.pengajarId)
              .get();

      if (doc.exists) {
        setState(() {
          pengajarData = doc.data();
        });
      } else {
        print("Dokumen tidak ditemukan untuk pengajarId: ${widget.pengajarId}");
      }
    } catch (e) {
      print("Gagal memuat data pengajar: $e");
    }
  }

  Stream<double> getAverageRatingStream(String pengajarId) {
    return FirebaseFirestore.instance
        .collection('ratings')
        .where('pengajarId', isEqualTo: pengajarId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return 0.0;
          final total = snapshot.docs.fold<double>(
            0.0,
            (sum, doc) => sum + (doc['rating'] ?? 0).toDouble(),
          );
          return total / snapshot.docs.length;
        });
  }

  @override
  Widget build(BuildContext context) {
    if (pengajarData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final name = pengajarData?['name'] ?? 'Tidak ada nama';
    final category = pengajarData?['category'] ?? '-';
    final bool status = pengajarData?['status'] ?? false;
    final university = pengajarData?['university'] ?? '-';
    final sertificationUrl = pengajarData?['sertificationUrl'] ?? '-';
    final contactNumber = pengajarData?['contactNumber'] ?? '-';
    final email = pengajarData?['email'] ?? '-';
    final photoPath = pengajarData?['photoPath'];
    final bankAccount = pengajarData?['bankAccount'] ?? '-';

    return Scaffold(
      bottomNavigationBar: const BottomBar(
        showBottomBar: true,
        disableHighlight: false,
      ),
      body: Column(
        children: [
          HeaderSmallBar(
            title: 'Tentang Pengajar',
            onBack: () => Navigator.pop(context),
          ),
          const SizedBox(height: 20),

          // Foto profil
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(child: _buildPhoto(pengajarData?['photoPath'])),
          ),

          const SizedBox(height: 20),

          // Nama, status, dan rating dinamis
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: status ? const Color(0xff00E732) : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status ? 'Aktif' : 'Tidak Aktif',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              StreamBuilder<double>(
                stream: getAverageRatingStream(widget.pengajarId),
                builder: (context, snapshot) {
                  final rating = snapshot.data ?? 0.0;
                  return Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Kategori
          Text(
            category,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 16),

          // Tabs navigasi
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTab('Jadwal', 0),
                _buildTab('Tentang', 1),
                _buildTab('Ulasan', 2),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Informasi detail
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 35),
                _buildInfoRow("Asal Universitas", university),
                _buildInfoRow("No. HP", contactNumber),
                _buildInfoRow("Email", email),
                _buildSertifikasiRow(sertificationUrl),
                _buildInfoRow("No. Rekening Bank", bankAccount),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(": ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildSertifikasiRow(String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 130,
            child: Text(
              "Sertifikasi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(": ", style: TextStyle(fontWeight: FontWeight.bold)),
          if (url != '-' && url.isNotEmpty)
            GestureDetector(
              onTap: () async {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Tidak dapat membuka dokumen"),
                    ),
                  );
                }
              },
              child: Text(
                "Lihat Sertifikat",
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          else
            const Text("-"),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return InkWell(
      onTap: () {
        if (index == _selectedIndex) return;
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => DetailPengajar(pengajarId: widget.pengajarId),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => UlasanPengajar(
                    pengajarId: widget.pengajarId,
                    pengajarRating: (pengajarData?['rating'] ?? 0.0).toDouble(),
                  ),
            ),
          );
        } else {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  _selectedIndex == index
                      ? const Color(0xFF9747FF)
                      : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color:
                _selectedIndex == index
                    ? const Color(0xFF9747FF)
                    : Colors.black,
            fontWeight:
                _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

Widget _buildPhoto(String? photoPath) {
  if (photoPath != null && photoPath.isNotEmpty) {
    final file = File(photoPath);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover, width: 120, height: 120);
    } else {
      return Image.asset(
        'assets/images/profile.png',
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    }
  } else {
    return Image.asset(
      'assets/images/profile.png',
      fit: BoxFit.cover,
      width: 120,
      height: 120,
    );
  }
}
