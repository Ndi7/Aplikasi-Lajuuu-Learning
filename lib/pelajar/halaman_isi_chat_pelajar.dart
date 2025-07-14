import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HalamanIsiChatPelajar extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String otherUserId;

  const HalamanIsiChatPelajar({
    Key? key,
    required this.chatId,
    required this.currentUserId,
    required this.otherUserId,
  }) : super(key: key);

  @override
  _HalamanIsiChatPelajarState createState() => _HalamanIsiChatPelajarState();
}

class _HalamanIsiChatPelajarState extends State<HalamanIsiChatPelajar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resetUnreadCount();
  }

  Future<void> _resetUnreadCount() async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .update({'unreadCount_${widget.currentUserId}': 0});
    } catch (e) {
      print("Gagal reset unread count: $e");
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final chatRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId);
    final timestamp = FieldValue.serverTimestamp();

    // 1️ Pastikan dokumen chat sudah ada (jika belum, buat)
    final chatSnapshot = await chatRef.get();
    if (!chatSnapshot.exists) {
      await chatRef.set({
        'users': [widget.currentUserId, widget.otherUserId],
        'lastMessage': '',
        'lastTimestamp': timestamp,
        'unreadCount_${widget.currentUserId}': 0,
        'unreadCount_${widget.otherUserId}': 0,
      });
    }

    // 2️ Simpan pesan baru
    await chatRef.collection('messages').add({
      'text': text,
      'senderId': widget.currentUserId,
      'receiverId': widget.otherUserId,
      'timestamp': timestamp,
    });

    await chatRef.set({
      'lastMessage': text,
      'lastTimestamp': timestamp,
      'unreadCount_${widget.otherUserId}': FieldValue.increment(1),
    }, SetOptions(merge: true));

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Obrolan dengan Pengajar",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('chats')
                        .doc(widget.chatId)
                        .collection('messages')
                        .orderBy('timestamp', descending: false)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("Belum ada pesan."));
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg['senderId'] == widget.currentUserId;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(msg['text'] ?? ''),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(8, 4, 8, 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Tulis pesan di sini...',
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
