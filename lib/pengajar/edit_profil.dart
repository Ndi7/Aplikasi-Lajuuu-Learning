import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplikasi_lajuuu_learning/widget/headersmall_bar.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _certificationUrlController = TextEditingController();
  final _bankAccountController = TextEditingController(); // ✅ Controller Baru

  String? _photoPath;
  File? _pickedImage;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('pengajar').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _contactController.text = data['contactNumber'] ?? '';
          _certificationUrlController.text = data['sertificationUrl'] ?? '';
          _bankAccountController.text = data['bankAccount'] ?? '';
          _photoPath = data['photoPath'];
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final data = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'contactNumber': _contactController.text.trim(),
        'sertificationUrl': _certificationUrlController.text.trim(),
        'bankAccount':
            _bankAccountController.text.trim(), // ✅ Simpan Bank Account
      };

      if (_pickedImage != null) {
        data['photoPath'] = _pickedImage!.path;
      }

      await _firestore.collection('pengajar').doc(user.uid).update(data);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Profil berhasil diperbarui")));

      Navigator.pop(context, _nameController.text.trim());
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        _photoPath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider =
        (_pickedImage != null)
            ? FileImage(_pickedImage!)
            : (_photoPath != null && File(_photoPath!).existsSync())
            ? FileImage(File(_photoPath!))
            : const AssetImage('assets/images/profile.png');

    return Scaffold(
      appBar: HeaderSmallBar(
        title: 'Edit Profil',
        onBack: () => Navigator.pop(context),
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: imageProvider as ImageProvider,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildTextField("Nama", _nameController),
                  SizedBox(height: 12),
                  _buildTextField(
                    "Email",
                    _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    "Kontak",
                    _contactController,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    "Link Sertifikasi",
                    _certificationUrlController,
                    keyboardType: TextInputType.url,
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    "No. Rekening Bank",
                    _bankAccountController,
                    keyboardType: TextInputType.number,
                  ), // ✅ Input Rekening
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateProfile();
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
