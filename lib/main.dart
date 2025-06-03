import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Login/started.dart';
import 'Login/login_student.dart';
import 'pelajar/halaman_utama.dart';
import 'pelajar/halaman_pesanan.dart';
import 'pelajar/halaman_chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartedScreen(), //ubah nama class kalau mau ke tampilan mana !
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomeScreen(),
        '/pesanan': (context) => HalamanPesanan(),
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}
