import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:aplikasi_lajuuu_learning/pelajar/jadwal_student.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/tentang_student.dart';
import 'package:aplikasi_lajuuu_learning/widget/headersmall_bar.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/bottom_bar.dart';

class UlasanPengajar extends StatefulWidget {
  final String pengajarId;
  final double pengajarRating;

  const UlasanPengajar({
    Key? key,
    required this.pengajarId,
    required this.pengajarRating,
  }) : super(key: key);

  @override
  State<UlasanPengajar> createState() => _UlasanPengajarState();
}

class _UlasanPengajarState extends State<UlasanPengajar> {
  int _selectedIndex = 2;
  Map<String, dynamic>? pengajarData;
  double _selectedRating = 0.0;
  final TextEditingController _ulasanController = TextEditingController();
  bool _isSubmitting = false;
  bool _sudahMemberiUlasan = false;
  String? _currentDocId;

  @override
  void initState() {
    super.initState();
    _loadPengajar();
    _loadExistingRating();
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

  Future<void> _loadExistingRating() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final docId = "${user.uid}_${widget.pengajarId}";
    final doc =
        await FirebaseFirestore.instance.collection('ratings').doc(docId).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _selectedRating = (data['rating'] ?? 0).toDouble();
        _ulasanController.text = data['ulasan'] ?? '';
        _sudahMemberiUlasan = true;
        _currentDocId = docId;
      });
    } else {
      _currentDocId = docId;
    }
  }

  Future<void> _submitRating() async {
    setState(() => _isSubmitting = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _currentDocId == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('ratings')
          .doc(_currentDocId)
          .set({
            'pengajarId': widget.pengajarId,
            'userId': user.uid,
            'rating': _selectedRating,
            'ulasan': _ulasanController.text,
            'timestamp': FieldValue.serverTimestamp(),
            'anonymous': true,
            'userDisplayName': user.displayName ?? 'Pengguna',
            'userPhotoUrl': user.photoURL ?? '',
          });
      setState(() {
        _sudahMemberiUlasan = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ulasan berhasil dikirim'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim ulasan: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  /// Method untuk stream rating rata-rata
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

  Widget buildPhoto(String? photoPath) {
    if (photoPath != null && photoPath.isNotEmpty) {
      final file = File(photoPath);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover, width: 120, height: 120);
      }
    }
    return Image.asset(
      'assets/images/profile.png',
      fit: BoxFit.cover,
      width: 120,
      height: 120,
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = pengajarData?['name'] ?? 'Memuat...';
    final category = pengajarData?['category'] ?? '-';
    final bool status = pengajarData?['status'] ?? false;

    return Scaffold(
      bottomNavigationBar: const BottomBar(
        showBottomBar: true,
        disableHighlight: false,
      ),
      body: Column(
        children: [
          HeaderSmallBar(
            title: 'Ulasan Pengajar',
            onBack: () => Navigator.pop(context),
          ),
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
            child: ClipOval(child: buildPhoto(pengajarData?['photoPath'])),
          ),
          const SizedBox(height: 16),

          // Nama, status, dan rating
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

              /// Stream rating bintang otomatis
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
          Text(
            category,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),

          // Tab bar dan ulasan
          _buildTabBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sudahMemberiUlasan
                      ? const Text(
                        'Anda sudah memberikan ulasan untuk pengajar ini.',
                        style: TextStyle(color: Colors.grey),
                      )
                      : _buildRatingForm(),

                  const Divider(),
                  const Text(
                    'Ulasan Pengguna',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildUlasanList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Berikan Ulasan Anda',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () => setState(() => _selectedRating = index + 1.0),
              child: Icon(
                index < _selectedRating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 36,
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _ulasanController,
          decoration: InputDecoration(
            hintText: 'Bagaimana pengalaman belajar Anda?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.all(16),
          ),
          maxLines: 4,
          minLines: 3,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9747FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _selectedRating > 0 ? _submitRating : null,
            child:
                _isSubmitting
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      'Kirim Ulasan',
                      style: TextStyle(fontSize: 16),
                    ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildUlasanList() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('ratings')
              .where('pengajarId', isEqualTo: widget.pengajarId)
              .orderBy('timestamp', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Belum ada ulasan',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return Column(
          children:
              snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return _buildUlasanItem(data);
              }).toList(),
        );
      },
    );
  }

  Widget _buildUlasanItem(Map<String, dynamic> ulasan) {
    final date = ulasan['timestamp']?.toDate();
    final formattedDate =
        date != null ? DateFormat('dd MMM yyyy, HH:mm').format(date) : '';
    final displayName =
        ulasan['anonymous'] == true
            ? anonymizeName(ulasan['userDisplayName'] ?? 'Pengguna')
            : ulasan['userDisplayName'] ?? 'Pengguna';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      (ulasan['anonymous'] == true ||
                              (ulasan['userPhotoUrl'] ?? '').isEmpty)
                          ? null
                          : NetworkImage(ulasan['userPhotoUrl']),
                  child:
                      (ulasan['anonymous'] == true ||
                              (ulasan['userPhotoUrl'] ?? '').isEmpty)
                          ? const Icon(Icons.person, size: 20)
                          : null,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      ulasan['rating'].toString(),
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(ulasan['ulasan'] ?? '', style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
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
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => TentangPengajar(pengajarId: widget.pengajarId),
            ),
          );
        } else {
          setState(() => _selectedIndex = index);
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

/// Utility: menyamarkan nama pengguna
String anonymizeName(String name) {
  if (name.length <= 2) return '*' * name.length;
  final firstTwo = name.substring(0, 2);
  final lastChar = name.substring(name.length - 1);
  final maxStars = 4;
  final starCount = (name.length - 3).clamp(1, maxStars);
  final stars = '*' * starCount;
  return '$firstTwo$stars$lastChar';
}
