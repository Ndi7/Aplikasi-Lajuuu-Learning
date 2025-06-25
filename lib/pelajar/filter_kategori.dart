import 'package:flutter/material.dart';

class FilterKategori extends StatefulWidget {
  final Function(String?) onSelectKategori;

  const FilterKategori({Key? key, required this.onSelectKategori})
    : super(key: key);

  @override
  State<FilterKategori> createState() => _FilterKategoriState();
}

class _FilterKategoriState extends State<FilterKategori> {
  final List<String> kategori = [
    'Pemrograman Dasar',
    'Rekayasa Mobile',
    'Bahasa Pemrograman Linux',
    'Bahasa Inggris Industri',
    'Desain UI/UX',
    'Python',
    'C++',
    'Javascript',
    'HTML dan CSS',
  ];

  String? selectedKategori;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.deepPurpleAccent,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Kategori',
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    kategori.map((item) {
                      final isSelected = item == selectedKategori;
                      return FilterChip(
                        label: Text(item),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedKategori = selected ? item : null;
                          });
                          widget.onSelectKategori(
                            selected ? item : null,
                          ); // Kirim null saat unselect
                        },
                        selectedColor: Colors.deepPurpleAccent,
                        checkmarkColor: Colors.white,
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                selectedKategori == null
                    ? 'Tidak ada kategori dipilih'
                    : 'Kategori dipilih: $selectedKategori',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
