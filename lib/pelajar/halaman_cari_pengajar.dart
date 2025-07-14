import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'filter_kategori.dart';
import 'bottom_bar.dart';
import 'jadwal_student.dart';

class SearchTutorScreen extends StatelessWidget {
  const SearchTutorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: const PengajarListPage(),
    );
  }
}

class Pengajar {
  final String id;
  final String name;
  final String category;
  final String photoPath;
  final bool status;

  Pengajar({
    required this.id,
    required this.name,
    required this.category,
    required this.photoPath,
    required this.status,
  });

  factory Pengajar.fromFirestore(String id, Map<String, dynamic> data) {
    return Pengajar(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      photoPath: data['photoPath'] ?? '',
      status: data['status'] ?? true,
    );
  }
}

class PengajarListPage extends StatefulWidget {
  const PengajarListPage({Key? key}) : super(key: key);

  @override
  State<PengajarListPage> createState() => _PengajarListPageState();
}

class _PengajarListPageState extends State<PengajarListPage> {
  List<Pengajar> allPengajar = [];
  List<Pengajar> filteredPengajar = [];

  String searchQuery = '';
  String? selectedCategory;
  bool showFilter = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPengajar();
  }

  Future<void> fetchPengajar() async {
    setState(() {
      isLoading = true;
    });

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('pengajar').get();
      final data =
          snapshot.docs
              .map((doc) => Pengajar.fromFirestore(doc.id, doc.data()))
              .toList();

      setState(() {
        allPengajar = data;
        filteredPengajar =
            data.where((pengajar) => pengajar.status == true).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterPengajar(String query, {String? kategori}) {
    final filtered =
        allPengajar.where((pengajar) {
          final pengajarName = pengajar.name.toLowerCase().trim();
          final pengajarCategory = pengajar.category.toLowerCase().trim();
          final pengajarStatus = pengajar.status;

          final queryLower = query.toLowerCase().trim();
          final kategoriDipilih = kategori?.toLowerCase().trim();

          final matchesName = pengajarName.contains(queryLower);
          final matchesCategory =
              kategori == null || pengajarCategory == kategoriDipilih;
          final isActive = pengajarStatus == true;

          return matchesName && matchesCategory && isActive;
        }).toList();

    setState(() {
      searchQuery = query;
      selectedCategory = kategori;
      filteredPengajar = filtered;
    });
  }

  void toggleFilter() {
    setState(() {
      showFilter = !showFilter;
    });
  }

  Widget buildPengajarImage(String photoPath) {
    if (photoPath.isNotEmpty) {
      if (photoPath.startsWith('http')) {
        return Image.network(
          photoPath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        );
      } else if (File(photoPath).existsSync()) {
        return Image.file(
          File(photoPath),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          'assets/images/profile_cute.jpg',
          width: 50,
          height: 50,
        );
      }
    } else {
      return Image.asset('assets/images/profile.png', width: 50, height: 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    double panelWidth = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Cari Pengajar",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
            onPressed: toggleFilter,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          onChanged: (value) {
                            filterPengajar(value, kategori: selectedCategory);
                          },
                          decoration: InputDecoration(
                            hintText: "Cari nama pengajar",
                            filled: true,
                            fillColor: Colors.grey[300],
                            prefixIcon: const Icon(Icons.search),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : filteredPengajar.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/no_data.png',
                                  width: 200,
                                  height: 200,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Tidak ada pengajar ditemukan.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            itemCount: filteredPengajar.length,
                            itemBuilder: (context, index) {
                              final item = filteredPengajar[index];
                              return Column(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ProfileScreen(
                                                  pengajarId: item.id,
                                                ),
                                          ),
                                        );
                                      },
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: buildPengajarImage(
                                          item.photoPath,
                                        ),
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.name,
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
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: const Text(
                                              "Aktif",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        "Kategori: ${item.category}",
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 1, color: Colors.grey),
                                ],
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
          if (showFilter)
            GestureDetector(
              onTap: toggleFilter,
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 0,
            bottom: 0,
            right: showFilter ? 0 : -panelWidth,
            child: Container(
              width: panelWidth,
              child: FilterKategori(
                onSelectKategori: (selected) {
                  filterPengajar(searchQuery, kategori: selected);
                  toggleFilter();
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(
        showBottomBar: true,
        disableHighlight: true,
      ),
    );
  }
}
