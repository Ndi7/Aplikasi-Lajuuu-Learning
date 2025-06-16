import 'package:aplikasi_lajuuu_learning/pelajar/tentang_student.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/ulasan_student.dart';
import 'package:aplikasi_lajuuu_learning/widget/headersmall_bar.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/bottom_bar.dart';
import 'package:flutter/material.dart';

class DetailPengajar extends StatelessWidget {
  const DetailPengajar({Key? key}) : super(key: key);

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
  int _selectedIndex = 0; // Jadwal tab is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(
        showBottomBar: true,
        disableHighlight: false,
      ),
      body: Column(
        children: [
          HeaderSmallBar(
            title: 'Profile', // Judul header
            onBack: () {
              Navigator.pop(context);
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

          // Profile Picture Section
          const SizedBox(height: 20),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).toInt()),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              //image disini
            ),
          ),

          // Name and Status
          const SizedBox(height: 20),
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
                  color: Color(0xff00E732),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Aktif',
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
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
          const SizedBox(height: 16),
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

          // Jadwal Content
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tentang',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Online',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Waktu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: [
                      _buildTimeSlot('15.00-15.10', false),
                      _buildTimeSlot('15.00-15.30', true),
                      _buildTimeSlot('15.00-16.00', false),
                      _buildTimeSlot('16.00-16.30', false),
                      _buildTimeSlot('19.00-20.00', false),
                      _buildTimeSlot('19.00-19.30', true),
                    ],
                  ),
                  const Spacer(),
                  _buildChatButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Navigation
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

        if (index == 1) {
          // Tab Tentang
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TentangPengajar()),
          );
        } else if (index == 2) {
          // Tab Ulasan
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UlasanPengajar()),
          );
        } else {
          // Untuk tab Jadwal, cukup ganti _selectedIndex
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

  Widget _buildTimeSlot(String time, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        time,
        style: TextStyle(
          fontSize: 14,
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildChatButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xff00E732),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'Chat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
