import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:aplikasi_lajuuu_learning/widget/headersmall_bar.dart';
import 'package:aplikasi_lajuuu_learning/pengajar/bottom_bar_teacher.dart';
import 'setting.dart';
import 'package:aplikasi_lajuuu_learning/Login/login_teacher.dart';

class ProfileScreenTeacher extends StatefulWidget {
  const ProfileScreenTeacher({Key? key}) : super(key: key);

  @override
  State<ProfileScreenTeacher> createState() => _ProfileScreenTeacherState();
}

class _ProfileScreenTeacherState extends State<ProfileScreenTeacher> {
  int _selectedTabIndex = 0;
  int likeCount = 0;
  bool liked = false;
  bool showReplyField = false;
  final TextEditingController _replyController = TextEditingController();
  Map<String, dynamic>? teacherData;

  @override
  void initState() {
    super.initState();
    fetchTeacherData();
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
        });
      }
    }
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
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

  Widget _buildTentangTab() {
    if (teacherData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
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
          _buildInfoRow("No. Hp", teacherData!['contacNumber'] ?? "-"),
          _buildInfoRow("Email", teacherData!['email'] ?? "-"),
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
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(children: [Expanded(child: Text(label)), Text(": $value")]),
    );
  }

  Widget _buildInfoLinkRow(String label, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          url.startsWith('http')
              ? GestureDetector(
                onTap: () async {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
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
              : Text(": $url"),
        ],
      ),
    );
  }

  Widget _buildUlasanTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rating dan Ulasan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/avatar.png'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Laju Learning",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Icon(Icons.star, color: Colors.amber, size: 16),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text("Pelajarannya mudah dimengerti"),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    showReplyField = !showReplyField;
                  });
                },
                child: const Text("Balas"),
              ),
              const SizedBox(width: 10),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    liked = !liked;
                    likeCount += liked ? 1 : -1;
                  });
                },
                icon: Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  color: liked ? Colors.red : Colors.grey,
                ),
                label: Text("Suka (\$likeCount)"),
              ),
            ],
          ),
          if (showReplyField)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _replyController,
                    decoration: const InputDecoration(
                      hintText: 'Tulis balasan...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_replyController.text.isNotEmpty) {
                        setState(() {
                          showReplyField = false;
                          _replyController.clear();
                        });
                      }
                    },
                    child: const Text('Kirim'),
                  ),
                ],
              ),
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
                      );
                    },
                    child: const Icon(Icons.settings, color: Colors.purple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile_cute.jpg'),
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
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Aktif",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const Text(
                  "4.8",
                  style: TextStyle(fontWeight: FontWeight.bold),
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
