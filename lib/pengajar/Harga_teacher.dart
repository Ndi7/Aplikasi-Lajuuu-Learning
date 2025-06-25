import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widget/headersmall_bar.dart';

class TambahJadwalScreen extends StatefulWidget {
  const TambahJadwalScreen({super.key});

  @override
  State<TambahJadwalScreen> createState() => _TambahJadwalScreenState();
}

class _TambahJadwalScreenState extends State<TambahJadwalScreen> {
  String selectedMode = 'Online';
  List<Map<String, TextEditingController>> scheduleList = [];

  @override
  void initState() {
    super.initState();
    _addScheduleField();
  }

  void _addScheduleField() {
    setState(() {
      scheduleList.add({
        'duration': TextEditingController(),
        'price': TextEditingController(),
      });
    });
  }

  Future<void> _saveSchedule() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User belum login.")));
      return;
    }

    final pricingRef = FirebaseFirestore.instance
        .collection('pengajar')
        .doc(uid)
        .collection('pricing');

    try {
      for (var item in scheduleList) {
        final durationText = item['duration']!.text.trim();
        final priceText = item['price']!.text.trim();

        if (durationText.isEmpty || priceText.isEmpty) continue;

        final duration = int.tryParse(durationText) ?? 0;
        final price = int.tryParse(priceText) ?? 0;

        if (duration <= 0 || price <= 0) continue;

        await pricingRef.add({
          'metode': selectedMode.toLowerCase(),
          'duration': duration,
          'price': price,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data harga berhasil disimpan')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    }
  }

  @override
  void dispose() {
    for (var item in scheduleList) {
      item['duration']?.dispose();
      item['price']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSmallBar(
        title: 'Tambah Harga',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<String>(
                  value: 'Online',
                  groupValue: selectedMode,
                  onChanged: (value) {
                    setState(() {
                      selectedMode = value!;
                    });
                  },
                  activeColor: Colors.deepPurple,
                ),
                const Text('Online'),
                const SizedBox(width: 20),
                Radio<String>(
                  value: 'Offline',
                  groupValue: selectedMode,
                  onChanged: (value) {
                    setState(() {
                      selectedMode = value!;
                    });
                  },
                  activeColor: Colors.deepPurple,
                ),
                const Text('Offline'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: scheduleList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: scheduleList[index]['duration'],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Durasi (menit)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: scheduleList[index]['price'],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Harga (Rp)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (index == scheduleList.length - 1)
                          IconButton(
                            onPressed: _addScheduleField,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.deepPurple,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _saveSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C4DFF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Simpan',
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
