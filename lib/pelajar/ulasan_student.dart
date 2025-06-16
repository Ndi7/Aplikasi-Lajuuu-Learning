import 'package:aplikasi_lajuuu_learning/pelajar/jadwal_student.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/tentang_student.dart';
import 'package:aplikasi_lajuuu_learning/widget/headersmall_bar.dart';
import 'package:flutter/material.dart';

class UlasanPengajar extends StatelessWidget {
  const UlasanPengajar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2; // Ulasan tab is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderSmallBar(
            title: 'Profile', // Judul header
            onBack: () {
              Navigator.pop(context); // Navigasi kembali
            },
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 15),
                child: const Text(
                  'Profil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          // Profile Section
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 60,
            //image disini
          ),
          const SizedBox(height: 16),

          // Name with active indicator and rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Aji wibowo S. Kom.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Aktif',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const Text('4.8', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),

          // Profession
          const SizedBox(height: 4),
          const Text(
            'Rekayasa Perangkat Lunak',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),

          // Tabs
          const SizedBox(height: 24),
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTab('Jadwal', 0),
                _buildTab('Tentang', 1),
                _buildTab('Ulasan', 2),
              ],
            ),
          ),

          // Rating and Review Section
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Rating dan Ulasan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Rating Stars
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(Icons.star_border, color: Colors.black54, size: 30);
            }),
          ),

          // Review Input
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Masukkan Ulasan Anda',
                hintStyle: const TextStyle(color: Colors.black38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Spacer to push bottom navigation to the bottom
          const Spacer(),

          // Bottom Navigation
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomBar(),
    );
  }

  Widget _buildTab(String title, int index) {
    return InkWell(
      onTap: () {
        if (index == _selectedIndex) {
          // Tab sudah aktif, tidak perlu melakukan apa-apa
          return;
        }

        if (index == 0) {
          // Tab Tentang
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPengajar()),
          );
        } else if (index == 1) {
          // Tab Ulasan
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TentangPengajar()),
          );
        } else {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  _selectedIndex == index
                      ? const Color(0xFF9747FF)
                      : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color:
                _selectedIndex == index
                    ? const Color(0xFF9747FF)
                    : Colors.black,
            fontWeight:
                _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
