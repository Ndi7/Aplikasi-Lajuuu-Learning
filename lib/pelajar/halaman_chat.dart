import 'package:flutter/material.dart';
import 'headersmall_bar.dart'; // Import file header

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ChatListPage(),
    );
  }
}

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  final List<Map<String, dynamic>> chats = const [
    {
      'nama': 'Aji Wibowo S. Kom.',
      'pesan': 'Terimakasih untuk materinya pak',
      'waktu': '15.00',
      'foto': '',
      'badge': 1,
    },
    {
      'nama': 'David Aguero S. SI.',
      'pesan': 'oke',
      'waktu': '11.32',
      'foto': '',
      'badge': 0,
    },
    {
      'nama': 'Ayu Ingrid S.kom, M. Kom.',
      'pesan': 'baik bu',
      'waktu': '09.11',
      'foto': '',
      'badge': 2,
    },
    {
      'nama': 'Cynthia Ningrum',
      'pesan': 'Saya akan coba kak',
      'waktu': '08.56',
      'foto': '',
      'badge': 0,
    },
    {
      'nama': 'Obaja Louis M. T.I.',
      'pesan': 'Ditunggu pembayarannya ya',
      'waktu': '07.12',
      'foto': '',
      'badge': 0,
    },
    {
      'nama': 'Hanaya',
      'pesan': 'Terimakasih ya😊',
      'waktu': 'Kemarin',
      'foto': '',
      'badge': 0,
    },
    {
      'nama': 'RizalMuk',
      'pesan': 'Oke Bro',
      'waktu': 'Kemarin',
      'foto': '',
      'badge': 0,
    },
    {
      'nama': 'Budiono',
      'pesan': 'Okee',
      'waktu': 'Selasa',
      'foto': '',
      'badge': 1,
    },
    {
      'nama': 'Gufar',
      'pesan': 'Yak semangat Lajuuu',
      'waktu': 'Selasa',
      'foto': '',
      'badge': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header menggunakan HeaderSmallBar
          HeaderSmallBar(
            title: 'Chat',
            onBack: () {
              // Aksi ketika tombol back ditekan
              Navigator.maybePop(context);
            },
          ),
          // List Chat
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final bool isUnread = chat['badge'] > 0;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          chat['foto'] != ''
                              ? NetworkImage(chat['foto'])
                              : null,
                      backgroundColor: Colors.grey,
                      child:
                          chat['foto'] == ''
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          chat['nama'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isUnread ? Colors.black : Colors.grey,
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 18,
                            height: 18,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Color(0xFF7C4DFF),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${chat['badge']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            chat['pesan'],
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          chat['waktu'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
