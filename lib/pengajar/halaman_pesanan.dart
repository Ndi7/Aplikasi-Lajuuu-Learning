import 'package:aplikasi_lajuuu_learning/pengajar/jadwal.dart';
import 'package:flutter/material.dart';
import '../widget/headersmall_bar.dart'; // Import HeaderSmallBar

class HalamanPesanan extends StatefulWidget {
  const HalamanPesanan({Key? key}) : super(key: key);

  @override
  _HalamanPesananState createState() => _HalamanPesananState();
}

class _HalamanPesananState extends State<HalamanPesanan>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Menggunakan HeaderSmallBar
          HeaderSmallBar(
            title: 'Pesanan', // Judul header
            onBack: () {
              Navigator.pop(context); // Navigasi kembali
            },
          ),
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF7C4DFF),
              tabs: const [
                Tab(text: 'DIPILIH'),
                Tab(text: 'SELESAI'),
                Tab(text: 'DITOLAK'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListView('Dipilih', const Color(0xFFDBE700), [
                  {
                    'name': 'Aji Wibowo S. Kom.',
                    'category': 'Pemrograman dasar',
                  },
                  {
                    'name': 'David Aguero S. SI.',
                    'category': 'Rekayasa Mobile',
                  },
                ]),
                _buildListView('Selesai', const Color(0xFF00A9E7), [
                  {
                    'name': 'Aji Wibowo S. Kom.',
                    'category': 'Pemrograman dasar',
                  },
                ]),
                _buildListView('Ditolak', const Color(0xFFE71F00), [
                  {
                    'name': 'David Aguero S. SI.',
                    'category': 'Rekayasa Mobile',
                  },
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(
    String status,
    Color color,
    List<Map<String, String>> items,
  ) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              // Navigasi ke halaman detail Anda
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPengajar()),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 60,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['category'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
