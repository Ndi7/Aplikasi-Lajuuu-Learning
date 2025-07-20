import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:aplikasi_lajuuu_learning/pengajar/halaman_utama.dart';
import 'halaman_isi_chat_pengajar.dart';
import 'package:aplikasi_lajuuu_learning/widget/headersmall_bar.dart';
import 'bottom_bar_teacher.dart';

class HalamanChat extends StatefulWidget {
  const HalamanChat({Key? key}) : super(key: key);

  @override
  State<HalamanChat> createState() => _HalamanChatState();
}

class _HalamanChatState extends State<HalamanChat> {
  final currentUser = FirebaseAuth.instance.currentUser;
  Set<String> selectedChats = {};
  bool isSelecting = false;

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
    for (var chatId in selectedChats) {
      await FirebaseFirestore.instance.collection('chats').doc(chatId).delete();
    }
    setState(() {
      selectedChats.clear();
      isSelecting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = currentUser?.uid;

    return Scaffold(
      appBar: HeaderSmallBar(
        title: 'Pesan',
        onBack: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomePageTeacher()),
            );
          }
        },
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelecting)
            Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${selectedChats.length} dipilih'),
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
            ),
          const BottomBarTeacher(
            showBottomBar: true,
            currentIndex: 2,
            disableHighlight: false,
          ),
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                setState(() => isSelecting = !isSelecting);
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                    final users = List<String>.from(chatDoc['users']);
                    final otherUserId = users.firstWhere(
                      (id) => id != currentUserId,
                    );
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
                        if (!userSnapshot.hasData) {
                          return const SizedBox.shrink();
                        }

                        final userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        final name = userData['name'] ?? 'Pengguna';
                        final photoUrl = userData['photoUrl'] as String?;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purpleAccent),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            onTap: () async {
                              if (isSelecting) {
                                toggleSelection(chatId);
                                return;
                              }

                              await FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(chatId)
                                  .update({'unreadCount_$currentUserId': 0});

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => HalamanIsiChatPengajar(
                                        chatId: chatId,
                                        currentUserId: currentUserId!,
                                        otherUserId: otherUserId,
                                      ),
                                ),
                              );
                            },
                            onLongPress: () => toggleSelection(chatId),
                            selected: selectedChats.contains(chatId),
                            leading: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage:
                                      photoUrl != null && photoUrl.isNotEmpty
                                          ? NetworkImage(photoUrl)
                                          : null,
                                  child:
                                      (photoUrl == null || photoUrl.isEmpty)
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
                                        color: Colors.red,
                                        shape: BoxShape.circle,
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
                                isSelecting
                                    ? Checkbox(
                                      value: selectedChats.contains(chatId),
                                      onChanged: (_) => toggleSelection(chatId),
                                    )
                                    : null,
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
