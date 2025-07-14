import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import 'package:aplikasi_lajuuu_learning/widget/headersmall_bar.dart';
import 'package:aplikasi_lajuuu_learning/pengajar/bottom_bar_teacher.dart';
import 'setting.dart';
import 'package:aplikasi_lajuuu_learning/Login/login_teacher.dart';

String anonymizeName(String name) {
  if (name.length <= 2) return '*' * name.length;
  final firstTwo = name.substring(0, 2);
  final lastChar = name.substring(name.length - 1);
  final maxStars = 4;
  final starCount = (name.length - 3).clamp(1, maxStars);
  final stars = '*' * starCount;
  return '$firstTwo$stars$lastChar';
}

class ProfileScreenTeacher extends StatefulWidget {
  const ProfileScreenTeacher({Key? key}) : super(key: key);

  @override
  State<ProfileScreenTeacher> createState() => _ProfileScreenTeacherState();
}

class _ProfileScreenTeacherState extends State<ProfileScreenTeacher> {
  int _selectedTabIndex = 0;
  Map<String, dynamic>? teacherData;
  double averageRating = 0.0;
  bool isActive = true;
  int? activeReplyIndex;
  final TextEditingController _editingReplyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTeacherData();
    _loadAverageRating();
  }

  @override
  void dispose() {
    _editingReplyController.dispose();
    super.dispose();
  }

  Future<void> fetchTeacherData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('pengajar')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        setState(() {
          teacherData = doc.data();
          isActive = doc['status'] ?? true;
        });
      }
    }
  }

  Future<void> _loadAverageRating() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final snapshot =
        await FirebaseFirestore.instance
            .collection('ratings')
            .where('pengajarId', isEqualTo: user.uid)
            .get();
    if (snapshot.docs.isNotEmpty) {
      final total = snapshot.docs.fold(0.0, (sum, doc) {
        return sum + (doc.data()['rating'] as num).toDouble();
      });
      setState(() {
        averageRating = total / snapshot.docs.length;
      });
    }
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
        if (index == 1) {
          _loadAverageRating();
        }
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey,
              fontSize: 16,
            ),
          ),
          Container(
            height: 2,
            width: 60,
            color: isSelected ? Colors.purple : Colors.transparent,
            margin: const EdgeInsets.only(top: 4),
          ),
        ],
      ),
    );
  }

  Widget _buildUlasanTab() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Tidak ada data pengguna.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('ratings')
              .where('pengajarId', isEqualTo: user.uid)
              .orderBy('timestamp', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Belum ada ulasan.'));
        }

        final ulasanList = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ulasanList.length,
          itemBuilder: (context, index) {
            final doc = ulasanList[index];
            final data = doc.data() as Map<String, dynamic>;
            final ulasan = data['ulasan'] ?? '';
            final rating = (data['rating'] ?? 0).toDouble();
            final reply = data['reply'];
            final liked = data['likedByTeacher'] ?? false;
            final timestamp = data['timestamp']?.toDate();
            final formattedDate =
                timestamp != null
                    ? DateFormat('dd MMM yyyy, HH:mm').format(timestamp)
                    : '';
            final isAnonymous = data['anonymous'] ?? true;
            final userName =
                isAnonymous
                    ? anonymizeName(data['userDisplayName'] ?? 'Pengguna')
                    : data['userDisplayName'] ?? 'Pengguna';
            final userPhotoUrl = data['userPhotoUrl'] ?? '';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        backgroundImage:
                            isAnonymous || userPhotoUrl.isEmpty
                                ? null
                                : NetworkImage(userPhotoUrl),
                        child:
                            isAnonymous || userPhotoUrl.isEmpty
                                ? const Icon(Icons.person, size: 20)
                                : null,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                Icons.star,
                                size: 16,
                                color: i < rating ? Colors.amber : Colors.grey,
                              );
                            }),
                          ),
                          if (formattedDate.isNotEmpty)
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(ulasan),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            activeReplyIndex =
                                activeReplyIndex == index ? null : index;
                            _editingReplyController.text = reply ?? '';
                          });
                        },
                        child: Text(
                          reply == null || reply.isEmpty
                              ? "Balas"
                              : "Edit Balasan",
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton.icon(
                        onPressed: () async {
                          try {
                            final newLike = !liked;
                            await FirebaseFirestore.instance
                                .collection('ratings')
                                .doc(doc.id)
                                .update({'likedByTeacher': newLike});
                          } catch (e) {
                            print('Gagal update like: $e');
                          }
                        },
                        icon: Icon(
                          liked ? Icons.favorite : Icons.favorite_border,
                          color: liked ? Colors.red : Colors.grey,
                        ),
                        label: Text(liked ? "Disukai" : "Suka"),
                      ),
                    ],
                  ),
                  if (activeReplyIndex == index)
                    Column(
                      children: [
                        TextField(
                          controller: _editingReplyController,
                          decoration: const InputDecoration(
                            hintText: 'Tulis balasan...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  activeReplyIndex = null;
                                  _editingReplyController.clear();
                                });
                              },
                              child: const Text('Batal'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                final replyText =
                                    _editingReplyController.text.trim();
                                if (replyText.isNotEmpty) {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('ratings')
                                        .doc(doc.id)
                                        .update({'reply': replyText});
                                    setState(() {
                                      activeReplyIndex = null;
                                      _editingReplyController.clear();
                                    });
                                  } catch (e) {
                                    print('Gagal update balasan: $e');
                                  }
                                }
                              },
                              child: const Text('Kirim'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (reply != null &&
                      reply.toString().isNotEmpty &&
                      activeReplyIndex != index)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Balasan: $reply",
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTentangTab() {
    if (teacherData == null)
      return const Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Nama", teacherData!['name'] ?? "-"),
          _buildInfoRow("Kategori", teacherData!['category'] ?? "-"),
          _buildInfoRow("Asal Universitas", teacherData!['university'] ?? "-"),
          _buildInfoLinkRow(
            "Sertifikasi",
            teacherData!['sertificationUrl'] ?? "-",
          ),
          _buildInfoRow("Kontak", teacherData!['contactNumber'] ?? "-"),
          _buildInfoRow("Email", teacherData!['email'] ?? "-"),
          _buildInfoRow(
            "No. Rekening Bank",
            teacherData!['bankAccount'] ?? "-",
          ),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreenTeacher()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.purple),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Keluar',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
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

  Widget _buildInfoLinkRow(String label, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
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
          Expanded(
            child:
                url.startsWith('http')
                    ? GestureDetector(
                      onTap: () async {
                        final uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Gagal membuka link')),
                          );
                        }
                      },
                      child: const Text(
                        "Lihat Sertifikat",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                    : Text(url),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSmallBar(
        title: 'Profil',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PengaturanPage(),
                        ),
                      ).then((_) {
                        fetchTeacherData();
                      });
                    },
                    child: const Icon(Icons.settings, color: Colors.purple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  teacherData?['photoPath'] != null &&
                          File(teacherData!['photoPath']).existsSync()
                      ? FileImage(File(teacherData!['photoPath']))
                      : const AssetImage('assets/images/profile.jpg')
                          as ImageProvider,
            ),
            const SizedBox(height: 12),
            Text(
              teacherData?['name'] ?? "Nama Pengajar",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              teacherData?['category'] ?? "Kategori",
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isActive ? "Aktif" : "Tidak Aktif",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.star, color: Colors.amber, size: 20),
                Text(
                  averageRating.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildTab("Tentang", 0), _buildTab("Ulasan", 1)],
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child:
                    _selectedTabIndex == 0
                        ? _buildTentangTab()
                        : _buildUlasanTab(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBarTeacher(
        showBottomBar: true,
        currentIndex: 3,
        disableHighlight: false,
      ),
    );
  }
}
