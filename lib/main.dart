import 'package:flutter/material.dart';
import 'headerbig_bar.dart';
import 'bottom_bar.dart';
import 'halaman_utama.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [HeaderBar(), Content()]),
      bottomNavigationBar: BottomBar(),
    );
  }
}
