import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'halaman_isi_chat_pelajar.dart';
import 'headersmall_bar.dart';
import 'bottom_bar.dart';

class HalamanChat extends StatefulWidget {
  const HalamanChat({Key? key}) : super(key: key);

  @override
  State<HalamanChat> createState() => _HalamanChatState();
}

class _HalamanChatState extends State<HalamanChat> {
  bool isSelectionMode = false;
  Set<String> selectedChats = {};

  void toggleSelection(String chatId) {
    setState(() {
      if (selectedChats.contains(chatId)) {
        selectedChats.remove(chatId);
      } else {
        selectedChats.add(chatId);
      }
    });
  }

  void deleteSelectedChats() async {
    for (String chatId in selectedChats) {
      await FirebaseFirestore.instance.collection('chats').doc(chatId).delete();
    }
    setState(() {
      isSelectionMode = false;
      selectedChats.clear();
    });
  }

  Widget _buildDeleteBottomBar() {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${selectedChats.length} dipilih"),
          TextButton.icon(
            onPressed: deleteSelectedChats,
            icon: const Icon(Icons.delete, color: Colors.deepPurple),
            label: const Text(
              'Hapus',
              style: TextStyle(color: Colors.deepPurple),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid;

    return Scaffold(
      appBar: HeaderSmallBar(
        title: 'Pesan',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      bottomNavigationBar:
          isSelectionMode
              ? _buildDeleteBottomBar()
              : const BottomBar(
                showBottomBar: true,
                currentIndex: 2,
                disableHighlight: false,
              ),
      backgroundColor: Colors.white,
      body:
          currentUser == null
              ? const Center(child: Text('User belum login'))
              : Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        setState(() {
                          isSelectionMode = !isSelectionMode;
                          selectedChats.clear();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('chats')
                              .where('users', arrayContains: currentUserId)
                              .orderBy('lastTimestamp', descending: true)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('Belum ada chat.'));
                        }

                        final chats = snapshot.data!.docs;

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            final chatDoc = chats[index];
                            final chatId = chatDoc.id;
                            final users = List<String>.from(
                              chatDoc['users'] ?? [],
                            );

                            if (users.length < 2)
                              return const SizedBox.shrink();

                            final otherUserId = users.firstWhere(
                              (id) => id != currentUserId,
                              orElse: () => '',
                            );
                            if (otherUserId.isEmpty)
                              return const SizedBox.shrink();

                            final lastMessage = chatDoc['lastMessage'] ?? '';
                            final unreadCount =
                                chatDoc['unreadCount_$currentUserId'] ?? 0;

                            return FutureBuilder<DocumentSnapshot>(
                              future:
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(otherUserId)
                                      .get(),
                              builder: (context, userSnapshot) {
                                if (!userSnapshot.hasData ||
                                    !userSnapshot.data!.exists) {
                                  return const SizedBox.shrink();
                                }

                                final userData =
                                    userSnapshot.data!.data()
                                        as Map<String, dynamic>;
                                final name = userData['name'] ?? 'Pengajar';
                                final photoPath =
                                    userData['photoPath'] as String?;

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.purpleAccent,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundColor: Colors.grey.shade300,
                                          backgroundImage:
                                              (photoPath != null &&
                                                      photoPath.isNotEmpty)
                                                  ? NetworkImage(photoPath)
                                                  : null,
                                          child:
                                              (photoPath == null ||
                                                      photoPath.isEmpty)
                                                  ? const Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                  )
                                                  : null,
                                        ),
                                        if (unreadCount > 0)
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red,
                                              ),
                                              child: Text(
                                                '$unreadCount',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    title: Text(name),
                                    subtitle: Text(lastMessage),
                                    trailing:
                                        isSelectionMode
                                            ? Checkbox(
                                              value: selectedChats.contains(
                                                chatId,
                                              ),
                                              onChanged:
                                                  (_) =>
                                                      toggleSelection(chatId),
                                            )
                                            : null,
                                    onTap: () async {
                                      if (isSelectionMode) {
                                        toggleSelection(chatId);
                                      } else {
                                        final jadwalSnapshot =
                                            await FirebaseFirestore.instance
                                                .collection('ajukan_jadwal')
                                                .where(
                                                  'userId',
                                                  isEqualTo: currentUserId,
                                                )
                                                .where(
                                                  'pengajarId',
                                                  isEqualTo: otherUserId,
                                                )
                                                .where(
                                                  'status',
                                                  whereIn: [
                                                    'Diterima',
                                                    'Selesai',
                                                  ],
                                                )
                                                .limit(1)
                                                .get();

                                        if (jadwalSnapshot.docs.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Pesanan belum disetujui. Anda belum bisa memulai chat.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        await FirebaseFirestore.instance
                                            .collection('chats')
                                            .doc(chatId)
                                            .update({
                                              'unreadCount_$currentUserId': 0,
                                            });

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => HalamanIsiChatPelajar(
                                                  chatId: chatId,
                                                  currentUserId: currentUserId!,
                                                  otherUserId: otherUserId,
                                                ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
