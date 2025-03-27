import 'package:flutter/material.dart';
import 'headersmall_bar.dart'; // Import HeaderSmallBar

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
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).toInt()),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              width: 36,
              height: 48,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/avatar_placeholder.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            title: Text(
              item['name'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              'Kategori: ${item['category']}',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
