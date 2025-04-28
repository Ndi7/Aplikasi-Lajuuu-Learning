import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan debug banner
      home: EditProfile(),
    );
  }
}

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name = "Lajuuu Learning";
  String email = "Lajuuu@gmail.com";
  String contact = "081122223333";
  String language = "Indonesia";
  String skill = "Flutter Developer";

  // Controller untuk menangani inputan teks
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _skillController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = name;
    _emailController.text = email;
    _contactController.text = contact;
    _skillController.text = skill;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: Text('Edit Profil', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF7C4DFF), // Menggunakan warna ungu
      ),
      body: SingleChildScrollView(
        // Membuat tampilan menjadi scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            SizedBox(height: 20),
            Text('Nama', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: "Masukkan nama Anda"),
            ),
            SizedBox(height: 16),
            Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(hintText: "Masukkan email Anda"),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            Text('Kontak', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(
                hintText: "Masukkan nomor kontak Anda",
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            Text('Keahlian', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _skillController,
              decoration: InputDecoration(hintText: "Masukkan keahlian Anda"),
            ),
            SizedBox(height: 16),
            Text('Bahasa', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Radio<String>(
                  value: 'Indonesia',
                  groupValue: language,
                  onChanged: (value) {
                    setState(() {
                      language = value!;
                    });
                  },
                ),
                Text('Indonesia'),
                Radio<String>(
                  value: 'Inggris',
                  groupValue: language,
                  onChanged: (value) {
                    setState(() {
                      language = value!;
                    });
                  },
                ),
                Text('Inggris'),
              ],
            ),
            SizedBox(height: 20),
            // Menambahkan tombol simpan dengan penataan yang baik
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Simpan perubahan ke dalam variabel state
                    name = _nameController.text;
                    email = _emailController.text;
                    contact = _contactController.text;
                    skill = _skillController.text;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profil berhasil diperbarui!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7C4DFF), // Menggunakan warna ungu
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(
                  'Simpan Perubahan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
