import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:aplikasi_lajuuu_learning/widget/headerbig_bar_teacher.dart';
import 'package:aplikasi_lajuuu_learning/pengajar/bottom_bar_teacher.dart';
import 'package:aplikasi_lajuuu_learning/pengajar/Form_shedule_teacher.dart';

class HomePageTeacher extends StatefulWidget {
  const HomePageTeacher({Key? key}) : super(key: key);

  @override
  State<HomePageTeacher> createState() => _HomePageTeacherState();
}

class _HomePageTeacherState extends State<HomePageTeacher> {
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  bool isOnline = true;
  String? namaPengajar = "Memuat...";

  @override
  void initState() {
    super.initState();
    _loadPengajarData();
  }

  Future<void> _loadPengajarData() async {
    if (uid != null) {
      try {
        final doc =
            await FirebaseFirestore.instance
                .collection('pengajar')
                .doc(uid)
                .get();
        if (doc.exists) {
          setState(() {
            namaPengajar = doc['name'] ?? '-';
          });
        }
      } catch (e) {
        setState(() {
          namaPengajar = 'Gagal memuat nama';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          HeaderbigBarTeacher(),
          Padding(
            padding: const EdgeInsets.only(top: 250, left: 16, right: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusBar(),
                  const SizedBox(height: 24),
                  const Text(
                    'Jadwal Tersedia',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  uid != null
                      ? _buildTimeSlots()
                      : const Text("Login terlebih dahulu."),
                  const SizedBox(height: 24),
                  const Text(
                    'Harga per Durasi:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  uid != null
                      ? _buildHargaList()
                      : const Text("Login terlebih dahulu."),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TimeAvailabilityScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const BottomBarTeacher(
        showBottomBar: true,
        currentIndex: 0,
        disableHighlight: false,
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/profile_cute.jpg'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              namaPengajar ?? 'Memuat...',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isOnline = !isOnline;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isOnline ? Colors.green[800] : Colors.red[800],
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Text(
                isOnline ? 'ON' : 'OFF',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('pengajar')
              .doc(uid)
              .collection('time_slots')
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        if (snapshot.data!.docs.isEmpty) return const Text("Belum ada jadwal.");

        final docs = snapshot.data!.docs;

        final onlineSlots =
            docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return (data['metode'] ?? 'online') == 'online';
            }).toList();

        final offlineSlots =
            docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return (data['metode'] ?? 'offline') == 'offline';
            }).toList();

        Widget buildSlotItem(Map<String, dynamic> data, Color color) {
          final start = data['startTime'] ?? '??';
          final end = data['endTime'] ?? '??';
          final isAvailable = data['available'] ?? true;

          return Container(
            width: 150,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isAvailable ? color : Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$start - $end',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Online:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  onlineSlots.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return buildSlotItem(data, Colors.green);
                  }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Offline:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  offlineSlots.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return buildSlotItem(data, Colors.blue);
                  }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHargaList() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('pengajar')
              .doc(uid)
              .collection('pricing')
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        if (snapshot.data!.docs.isEmpty) return const Text("Belum ada harga.");

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final duration = doc['duration'] ?? '??';
                final price = doc['price'] ?? 0;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$duration - Rp$price',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}
