import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Login/started.dart';
import 'Login/login_teacher.dart';
import 'Login/login_student.dart';
import 'Login/register_page.dart';

import 'pengajar/halaman_utama.dart';
import 'pelajar/halaman_utama.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/halaman_chat.dart';
import 'pengajar/Form_shedule_teacher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _handleRedirect() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return StartedScreen();
    }

    // Cek apakah user ini adalah pengajar
    final doc =
        await FirebaseFirestore.instance
            .collection('pengajar')
            .doc(user.uid)
            .get();

    if (doc.exists) {
      return const HomePageTeacher();
    } else {
      return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lajuuu Learning',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: FutureBuilder(
        future: _handleRedirect(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Terjadi kesalahan: ${snapshot.error}')),
            );
          } else {
            return snapshot.data as Widget;
          }
        },
      ),
      routes: {
        '/getstarted': (context) => TimeAvailabilityScreen(),
        '/login': (context) => const LoginScreenStudent(),
        '/loginPengajar': (context) => const LoginPageGuru(),
        '/register': (context) => const RegisterScreen(),
        '/homePengajar': (context) => const HomePageTeacher(),
        '/homePelajar': (context) => const HomeScreen(),
        '/chat': (context) {
          final userId = FirebaseAuth.instance.currentUser?.uid;

          if (userId == null) {
            return const LoginScreenStudent(); // fallback jika user belum login
          }

          return FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance
                    .collection('pengajar')
                    .doc(userId)
                    .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('Error: ${snapshot.error}')),
                );
              }

              final isPengajar = snapshot.data!.exists;
              if (isPengajar) {
                return const HalamanChat(); // pengajar
              } else {
                return const HalamanChat(); // pelajar
              }
            },
          );
        },
      },
    );
  }
}
