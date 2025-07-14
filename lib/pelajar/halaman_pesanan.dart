import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'headersmall_bar.dart';
import 'bottom_bar.dart';
import 'halaman_isi_chat_pelajar.dart';

class HalamanPesanan extends StatefulWidget {
  const HalamanPesanan({Key? key}) : super(key: key);

  @override
  HalamanPesananState createState() => HalamanPesananState();
}

class HalamanPesananState extends State<HalamanPesanan>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      bottomNavigationBar: const BottomBar(
        showBottomBar: true,
        currentIndex: 1,
        disableHighlight: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          HeaderSmallBar(
            title: 'Pesanan',
            onBack: () {
              Navigator.pop(context);
            },
          ),
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF7C4DFF),
              tabs: const [
                Tab(text: 'DIPILIH'),
                Tab(text: 'SELESAI'),
                Tab(text: 'DITOLAK'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStreamListView(
                  currentUserId,
                  'Menunggu Konfirmasi',
                  const Color(0xFFDBE700),
                  'Dipilih',
                ),
                _buildStreamListView(
                  currentUserId,
                  'Diterima',
                  const Color(0xFF00A9E7),
                  'Selesai',
                ),
                _buildStreamListView(
                  currentUserId,
                  'Ditolak',
                  const Color(0xFFE71F00),
                  'Ditolak',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamListView(
    String currentUserId,
    String statusFilter,
    Color color,
    String label,
  ) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('ajukan_jadwal')
              .where('status', isEqualTo: statusFilter)
              .orderBy('createdAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Belum ada pesanan.'));
        }

        final items = snapshot.data!.docs;

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final data = items[index].data() as Map<String, dynamic>;
            final pengajarId = data['pengajarId'] ?? '';
            final namaPengajar = data['nama_pengajar'] ?? '';

            return Card(
              color: Colors.white,
              shadowColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Color(0xFF7C4DFF), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ListTile(
                      leading: FutureBuilder<DocumentSnapshot>(
                        future:
                            FirebaseFirestore.instance
                                .collection('pengajar')
                                .doc(pengajarId)
                                .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage(
                                'assets/images/profile.png',
                              ),
                            );
                          }

                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return const CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage(
                                'assets/images/profile.png',
                              ),
                            );
                          }

                          final pengajarData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return CircleAvatar(
                            radius: 24,
                            backgroundImage: _buildPhotoPengajar(
                              pengajarData['photoPath'],
                            ),
                          );
                        },
                      ),
                      title: Text(
                        namaPengajar,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Kategori: ${data['mata_kuliah'] ?? '-'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    if (statusFilter == 'Diterima')
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final chatId = generateChatId(
                              currentUserId.trim(),
                              pengajarId.trim(),
                            );
                            final chatRef = FirebaseFirestore.instance
                                .collection('chats')
                                .doc(chatId);

                            final chatDoc = await chatRef.get();
                            if (!chatDoc.exists) {
                              await chatRef.set({
                                'users': [
                                  currentUserId.trim(),
                                  pengajarId.trim(),
                                ],
                                'lastMessage': '',
                                'lastTimestamp': FieldValue.serverTimestamp(),
                                'createdAt': FieldValue.serverTimestamp(),
                                'unreadCount_${currentUserId.trim()}': 0,
                                'unreadCount_${pengajarId.trim()}': 0,
                              });
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => HalamanIsiChatPelajar(
                                      chatId: chatId,
                                      currentUserId: currentUserId,
                                      otherUserId: pengajarId,
                                    ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat, color: Colors.white),
                          label: const Text(
                            'Mulai Percakapan',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String generateChatId(String user1, String user2) {
    final users = [user1, user2]..sort();
    return users.join('_');
  }
}

ImageProvider _buildPhotoPengajar(String? photoPath) {
  if (photoPath == null || photoPath.isEmpty) {
    return const AssetImage('assets/images/profile.png');
  }

  if (photoPath.startsWith('/data/')) {
    return FileImage(File(photoPath));
  }

  if (photoPath.startsWith('http')) {
    return NetworkImage(photoPath);
  }

  return const AssetImage('assets/images/profile.png');
}
