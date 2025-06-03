import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:aplikasi_lajuuu_learning/widget/headersmall_bar.dart';

void main() {
  runApp(
    MaterialApp(home: EditProfilePage(), debugShowCheckedModeBanner: false),
  );
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController _nameController = TextEditingController(
    text: 'Aji Wibowo, S.Kom',
  );
  TextEditingController _emailController = TextEditingController(
    text: 'Wibowo@gmail.com',
  );
  TextEditingController _contactController = TextEditingController(
    text: '08112223333',
  );
  String? _certificationFileName;

  Future<void> _pickCertificationFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _certificationFileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSmallBar(
        title: 'Edit Profil',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 330,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Foto Profil
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                          'assets/images/get_started1.png',
                        ), // Ubah sesuai path
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            // Tambahkan aksi ubah foto
                          },
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Nama
                  _buildTextField("Nama", _nameController),
                  SizedBox(height: 12),

                  // Email
                  _buildTextField(
                    "Email",
                    _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 12),

                  // Kontak
                  _buildTextField(
                    "Kontak",
                    _contactController,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 12),

                  // Sertifikasi
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Sertifikasi",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickCertificationFile,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _certificationFileName ?? "Upload file sertifikat",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Tombol Edit
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Simpan data
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Profil berhasil diedit")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Edit",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      validator:
          (value) =>
              value == null || value.isEmpty
                  ? '$label tidak boleh kosong'
                  : null,
    );
  }
}
