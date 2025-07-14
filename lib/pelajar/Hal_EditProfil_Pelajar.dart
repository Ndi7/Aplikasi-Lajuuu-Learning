import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'headersmall_bar.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  String email = '';

  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        email = user.email ?? '';
      });

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        _nameController.text = data['name'] ?? '';
        _contactController.text = data['contactNumber'] ?? '';

        if (data['photoPath'] != null) {
          final file = File(data['photoPath']);
          if (await file.exists()) {
            setState(() {
              _pickedImage = file;
            });
          }
        }
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final profileData = {
      'name': _nameController.text,
      'contactNumber': _contactController.text,
      'email': user.email,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (_pickedImage != null) {
      profileData['photoPath'] = _pickedImage!.path;
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(profileData, SetOptions(merge: true));
    await _firestore
        .collection('pelajar')
        .doc(user.uid)
        .set(profileData, SetOptions(merge: true));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Profil berhasil diperbarui!')));
    Navigator.pop(context);
  }

  Widget _buildProfilePhoto() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
          backgroundColor: Colors.grey[300],
          child:
              _pickedImage == null
                  ? Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: IconButton(
            icon: Icon(Icons.edit, color: Colors.purple),
            onPressed: _pickImage,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSmallBar(
        title: 'Edit Profil',
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildProfilePhoto()),
            SizedBox(height: 20),
            Text('Nama', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: "Masukkan nama Anda"),
            ),
            SizedBox(height: 16),
            Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(email, style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 16),
            Text('Kontak', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(
                hintText: "Masukkan nomor kontak Anda",
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7C4DFF),
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
