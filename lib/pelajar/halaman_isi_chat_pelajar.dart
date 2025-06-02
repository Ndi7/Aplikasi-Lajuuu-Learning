import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ChatScreen(), debugShowCheckedModeBanner: false);
  }
}

class ChatMessage {
  final String message;
  final String time;
  final bool isSender;

  ChatMessage({
    required this.message,
    required this.time,
    required this.isSender,
  });
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = []; // Kosongkan pesan awal
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Di sinilah Anda seharusnya mengirim pesan ke Firebase terlebih dahulu
    // Setelah berhasil disimpan di Firebase, baru tambahkan ke _messages

    final now = DateTime.now();
    final formattedTime = DateFormat('HH.mm').format(now);

    setState(() {
      _messages.add(
        ChatMessage(message: text, time: formattedTime, isSender: true),
      );
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment:
                        msg.isSender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment:
                          msg.isSender
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 14,
                          ),
                          margin: EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color:
                                msg.isSender
                                    ? Color(0xFFD5C4F4)
                                    : Color(0xFFEAEAEA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(msg.message),
                        ),
                        Text(
                          msg.time,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Color(0xFF8B5CF6),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: AssetImage("assets/avatar.png")),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "lajuuu",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Online",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Ketik Pesan",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () => _sendMessage(_controller.text),
            child: CircleAvatar(
              backgroundColor: Color(0xFF8B5CF6),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
