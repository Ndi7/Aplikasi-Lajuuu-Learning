import 'package:aplikasi_lajuuu_learning/pelajar/tentang_student.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/ulasan_student.dart';
import 'package:aplikasi_lajuuu_learning/widget/headersmall_bar.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/bottom_bar.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/checkout_page.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DetailPengajar extends StatelessWidget {
  final String pengajarId;
  const DetailPengajar({Key? key, required this.pengajarId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ProfileScreen(pengajarId: pengajarId),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final String pengajarId;
  const ProfileScreen({Key? key, required this.pengajarId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic>? pengajarData;
  Map<String, dynamic>? selectedSlot;
  String? selectedMode;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadPengajar();
  }

  Future<void> _loadPengajar() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('pengajar')
            .doc(widget.pengajarId)
            .get();

    if (doc.exists) {
      setState(() {
        pengajarData = doc.data();
      });
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

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final timeSlotsRef = FirebaseFirestore.instance
        .collection('pengajar')
        .doc(widget.pengajarId)
        .collection('time_slots');

    final pricingRef = FirebaseFirestore.instance
        .collection('pengajar')
        .doc(widget.pengajarId)
        .collection('time_slots');

    final name = pengajarData?['name'] ?? 'Memuat...';
    final category = pengajarData?['category'] ?? '...';
    final bool status = pengajarData?['status'] ?? false;

    return Scaffold(
      appBar: HeaderSmallBar(
        title: 'Profile',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      bottomNavigationBar: const BottomBar(
        showBottomBar: true,
        disableHighlight: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
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
          Text(
            category,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child:
                  _selectedIndex == 0
                      ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Waktu Ketersediaan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Jadwal Online',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildTimeSlots(timeSlotsRef, 'online'),
                            const SizedBox(height: 20),
                            const Text(
                              'Jadwal Offline',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildTimeSlots(timeSlotsRef, 'offline'),
                            const SizedBox(height: 30),
                            const Text(
                              'Harga Kelas',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildPricing(pricingRef),
                            const SizedBox(height: 30),
                            Center(
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff00E732),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  onPressed: () {
                                    AjukanJadwalModal(
                                      pengajarId: widget.pengajarId,
                                      nama: pengajarData?['name'] ?? '-',
                                      mataKuliah:
                                          pengajarData?['category'] ?? '-',
                                      metode: selectedMode ?? '-',
                                      tanggal: _formatDate(selectedDate),
                                      waktu:
                                          '${selectedSlot?['startTime']} - ${selectedSlot?['endTime']}',
                                    ).show(context);
                                  },
                                  child: const Text(
                                    'Ajukan Jadwal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      )
                      : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return InkWell(
      onTap: () {
        if (index == _selectedIndex) return;
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      ProfileScreenPengajar(pengajarId: widget.pengajarId),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => UlasanPengajar(
                    pengajarId: widget.pengajarId,
                    pengajarRating:
                        (pengajarData?['ratings'] ?? 0.0).toDouble(),
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

  Widget _buildTimeSlots(CollectionReference ref, String metode) {
    return StreamBuilder<QuerySnapshot>(
      stream: ref.where('metode', isEqualTo: metode).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text('Gagal memuat data.');
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final slots = snapshot.data!.docs;
        if (slots.isEmpty) return const Text('Tidak ada jadwal.');
        return Wrap(
          spacing: 8,
          runSpacing: 10,
          children:
              slots.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return _buildTimeSlot(
                  '${data['startTime']} - ${data['endTime']}',
                  true,
                  data,
                  metode,
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildPricing(CollectionReference ref) {
    return StreamBuilder<QuerySnapshot>(
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text('Gagal memuat data.');
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final items = snapshot.data!.docs;
        if (items.isEmpty) return const Text('Belum ada data harga.');
        return Column(
          children:
              items.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text('${data['duration']} menit'),
                  subtitle: Text('Rp ${data['price']} (${data['metode']})'),
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildTimeSlot(
    String time,
    bool isSelected,
    Map<String, dynamic> data,
    String metode,
  ) {
    bool isCurrentSelected =
        selectedSlot?['startTime'] == data['startTime'] &&
        selectedSlot?['endTime'] == data['endTime'];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSlot = data;
          selectedMode = metode;

          if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
            selectedDate = (data['createdAt'] as Timestamp).toDate();
          } else {
            selectedDate = DateTime.now();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrentSelected ? Colors.green : Colors.lightGreenAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          time,
          style: TextStyle(
            fontSize: 14,
            color: isCurrentSelected ? Colors.white : Colors.black87,
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
