import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        _contactController.text = data['contact'] ?? '';
      }
    }
  }

  Future<void> _saveProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final profileData = {
      'name': _nameController.text,
      'contactNumber': _contactController.text,
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    };

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
    Navigator.pop(context); // kembali ke halaman profil
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
