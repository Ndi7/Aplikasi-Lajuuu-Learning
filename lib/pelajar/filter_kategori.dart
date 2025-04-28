import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(home: DaftarMateriPage(), debugShowCheckedModeBanner: false),
  );
}

class DaftarMateriPage extends StatefulWidget {
  @override
  _DaftarMateriPageState createState() => _DaftarMateriPageState();
}

class _DaftarMateriPageState extends State<DaftarMateriPage> {
  bool showFilter = false;

  void toggleFilter() {
    setState(() {
      showFilter = !showFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    double panelWidth =
        MediaQuery.of(context).size.width * 0.5; // Setengah layar

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Materi'),
        actions: [
          IconButton(icon: Icon(Icons.filter_list), onPressed: toggleFilter),
        ],
      ),
      body: Stack(
        children: [
          // Konten utama
          Center(
            child: Text(
              'Konten Materi di Sini',
              style: TextStyle(fontSize: 20),
            ),
          ),

          // Overlay hitam saat filter aktif
          if (showFilter)
            GestureDetector(
              onTap: toggleFilter,
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),

          // Panel filter setengah layar (slide dari kiri)
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 0,
            bottom: 0,
            left: showFilter ? 0 : -panelWidth,
            child: Container(
              width: panelWidth, // panel hanya setengah lebar layar
              child: FilterKategori(),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterKategori extends StatelessWidget {
  final List<String> kategori = [
    'Pemrograman Dasar',
    'Rekayasa mobile',
    'Bahasa pemrograman linux',
    'Bahasa Inggris Industri',
    'Desain UI/UX',
    'Python',
    'C++',
    'Javascript',
    'HTML dan CSS',
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header ungu
          Container(
            width: double.infinity,
            color: Colors.deepPurpleAccent,
            padding: EdgeInsets.all(16),
            child: Text(
              'Filter',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 8),

          // Label Kategori
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Kategori',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          SizedBox(height: 8),

          // Chip List
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    kategori.map((item) {
                      return FilterChip(
                        label: Text(item),
                        onSelected: (bool selected) {},
                        selected: false,
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
