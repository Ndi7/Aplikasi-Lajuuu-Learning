import 'package:flutter/material.dart';
import 'filter_kategori.dart';
import 'bottom_bar.dart';

void main() {
  runApp(const SearchTutorScreen());
}

class SearchTutorScreen extends StatelessWidget {
  const SearchTutorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Warna dasar putih
      ),
      home: PengajarListPage(),
    );
  }
}

class PengajarListPage extends StatelessWidget {
  PengajarListPage({super.key});

  final List<Map<String, String>> pengajar = [
    {
      'nama': 'Aji Wibowo S. Kom.',
      'kategori': 'Pemrograman dasar',
      'foto': 'https://via.placeholder.com/150',
    },
    {
      'nama': 'David Aguero S. SI.',
      'kategori': 'Rekayasa Mobile',
      'foto': 'https://via.placeholder.com/150',
    },
    {
      'nama': 'Ayu Ingrid S.kom, M. Kom.',
      'kategori': 'Bahasa pemrograman Linux',
      'foto': 'https://via.placeholder.com/150',
    },
    {
      'nama': 'Cynthia Ningrum',
      'kategori': 'Bahasa Inggris industri',
      'foto': 'https://via.placeholder.com/150',
    },
    {
      'nama': 'Obaja Louis M. T.I.',
      'kategori': 'Design UI/UX',
      'foto': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 30), // Jarak dari atas
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Cari pengajar",
                        filled: true, // Aktifkan warna latar
                        fillColor: Colors.grey[300], // Warna abu-abu muda
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none, // Hapus border
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.filter_alt_outlined),
                  onPressed: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: "Filter",
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Align(
                          alignment:
                              Alignment.centerRight, // Di sisi kiri layar
                          child: Material(
                            color: Colors.white,
                            elevation: 8,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.width *
                                  0.5, // Setengah layar
                              height: MediaQuery.of(context).size.height,
                              child:
                                  FilterKategori(), // Ganti dengan isi filternya
                            ),
                          ),
                        );
                      },
                      transitionBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        final offsetAnimation = Tween<Offset>(
                          begin: const Offset(1, 0), // Dari kiri ke kanan
                          end: Offset.zero,
                        ).animate(animation);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20), // Jarak ke bawah dari kotak pencarian
            Expanded(
              child: ListView.builder(
                itemCount: pengajar.length,
                itemBuilder: (context, index) {
                  final item = pengajar[index];
                  return Column(
                    children: [
                      Container(
                        color: Colors.white, // Background putih
                        child: ListTile(
                          leading: Container(
                            width: 30,
                            height: 80,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(item['foto']!),
                                fit:
                                    BoxFit.cover, // Gambar mengisi seluruh area
                              ),
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // Radius kecil
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['nama']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  "Aktif",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10, // Ukuran font kecil
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text("Kategori: ${item['kategori']}"),
                        ),
                      ),
                      const Divider(
                        height: 1, // Tinggi garis
                        color: Colors.grey, // Warna garis pemisah
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        showBottomBar: true,
        disableHighlight: true,
      ),
    );
  }
}
