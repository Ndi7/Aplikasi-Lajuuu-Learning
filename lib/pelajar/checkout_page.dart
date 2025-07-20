import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AjukanJadwalModal extends StatefulWidget {
  final String pengajarId;
  final String nama;
  final String mataKuliah;
  final String metode;
  final String tanggal;
  final String waktu;

  const AjukanJadwalModal({
    Key? key,
    required this.pengajarId,
    required this.nama,
    required this.mataKuliah,
    required this.metode,
    required this.tanggal,
    required this.waktu,
  }) : super(key: key);

  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => this,
    );
  }

  @override
  State<AjukanJadwalModal> createState() => _AjukanJadwalModalState();
}

class _AjukanJadwalModalState extends State<AjukanJadwalModal> {
  File? _imageFile;
  String? _imageBase64;
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageFile = File(picked.path);
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  Future<Map<String, dynamic>> _getPelajarData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (doc.exists) {
      return {
        'userId': user.uid,
        'namaPelajar': doc.data()?['name'] ?? '',
        'photoPelajar': doc.data()?['photoPath'] ?? '',
      };
    } else {
      return {'userId': user.uid, 'namaPelajar': '', 'photoPelajar': ''};
    }
  }

  Future<void> _submitRequest() async {
    if (_imageBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon unggah bukti pembayaran')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final pelajarData = await _getPelajarData();

      await FirebaseFirestore.instance.collection('ajukan_jadwal').add({
        'userId': pelajarData['userId'],
        'namaPelajar': pelajarData['namaPelajar'],
        'photoPelajar': pelajarData['photoPelajar'],
        'pengajarId': widget.pengajarId,
        'nama_pengajar': widget.nama,
        'mata_kuliah': widget.mataKuliah,
        'metode': widget.metode,
        'tanggal': widget.tanggal,
        'waktu': widget.waktu,
        'bukti_pembayaran_base64': _imageBase64,
        'status': 'Menunggu Konfirmasi',
        'createdAt': Timestamp.now(),
      });

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengajuan berhasil dikirim')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengajukan: $e')));
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  String _formatTanggal(String tanggal) {
    try {
      final parsedDate = DateTime.parse(tanggal);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return tanggal;
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Nama Pengajar', widget.nama),
            _buildInfoRow('Mata Kuliah', widget.mataKuliah),
            _buildInfoRow('Metode', widget.metode),
            _buildInfoRow('Tanggal', _formatTanggal(widget.tanggal)),
            _buildInfoRow('Waktu', widget.waktu),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child:
                    _imageFile != null
                        ? Image.file(_imageFile!, height: 100)
                        : Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Center(
                            child: Text(
                              'Upload Bukti Pembayaran',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed: _isSubmitting ? null : _submitRequest,
                child:
                    _isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text(
                          'Ajukan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
