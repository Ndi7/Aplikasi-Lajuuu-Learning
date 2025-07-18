import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widget/headersmall_bar.dart';
import 'package:aplikasi_lajuuu_learning/pengajar/halaman_utama.dart';

class TimeAvailabilityScreen extends StatefulWidget {
  const TimeAvailabilityScreen({Key? key}) : super(key: key);

  @override
  _TimeAvailabilityScreenState createState() => _TimeAvailabilityScreenState();
}

class _TimeAvailabilityScreenState extends State<TimeAvailabilityScreen> {
  List<ScheduleEntry> scheduleList = [];

  TimeOfDay selectedStartTime = const TimeOfDay(hour: 09, minute: 00);
  TimeOfDay selectedEndTime = const TimeOfDay(hour: 10, minute: 00);

  final TextEditingController durationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String selectedMode = 'online'; // default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSmallBar(
        title: 'Jadwal & Harga',
        onBack: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTimePickerRow(),
            const SizedBox(height: 12),
            _buildDurationPriceInput(),
            const SizedBox(height: 12),
            _buildModeSelector(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Tambah Jadwal',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _addScheduleEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C4DFF),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  scheduleList.isEmpty
                      ? const Center(child: Text('Belum ada jadwal.'))
                      : ListView.builder(
                        itemCount: scheduleList.length,
                        itemBuilder: (context, index) {
                          final item = scheduleList[index];
                          return ListTile(
                            title: Text(
                              '${_formatTime(item.start)} - ${_formatTime(item.end)} | ${item.duration} mnt | Rp${item.price} (${item.metode})',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  scheduleList.removeAt(index);
                                });
                              },
                            ),
                          );
                        },
                      ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveToFirestore,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C4DFF),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTimeButton('Mulai', selectedStartTime, (picked) {
          if (picked != null) {
            setState(() {
              selectedStartTime = picked;
            });
          }
        }),
        _buildTimeButton('Selesai', selectedEndTime, (picked) {
          if (picked != null) {
            setState(() {
              selectedEndTime = picked;
            });
          }
        }),
      ],
    );
  }

  Widget _buildTimeButton(
    String label,
    TimeOfDay time,
    void Function(TimeOfDay?) onTimePicked,
  ) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ElevatedButton(
          onPressed: () async {
            TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: time,
            );
            onTimePicked(picked);
          },
          child: Text(_formatTime(time)),
        ),
      ],
    );
  }

  Widget _buildDurationPriceInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: durationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Durasi (menit)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Harga (Rp)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<String>(
          value: 'online',
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
          value: 'offline',
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
    );
  }

  void _addScheduleEntry() {
    final startMinutes = selectedStartTime.hour * 60 + selectedStartTime.minute;
    final endMinutes = selectedEndTime.hour * 60 + selectedEndTime.minute;

    if (startMinutes >= endMinutes) {
      _showMessage("Waktu mulai harus sebelum waktu selesai.");
      return;
    }

    final duration = int.tryParse(durationController.text.trim()) ?? 0;
    final price = int.tryParse(priceController.text.trim()) ?? 0;

    if (duration <= 0 || price <= 0) {
      _showMessage("Durasi dan harga harus diisi.");
      return;
    }

    setState(() {
      scheduleList.add(
        ScheduleEntry(
          start: selectedStartTime,
          end: selectedEndTime,
          duration: duration,
          price: price,
          metode: selectedMode,
        ),
      );
      durationController.clear();
      priceController.clear();
    });
  }

  Future<void> _saveToFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final slotsRef = FirebaseFirestore.instance
        .collection('pengajar')
        .doc(uid)
        .collection('time_slots');

    for (var item in scheduleList) {
      await slotsRef.add({
        'startTime': _formatTime(item.start),
        'endTime': _formatTime(item.end),
        'duration': item.duration,
        'price': item.price,
        'metode': item.metode,
        'available': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    _showMessage('Jadwal berhasil disimpan.');
    setState(() => scheduleList.clear());

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePageTeacher()),
        (route) => false,
      );
    });
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class ScheduleEntry {
  final TimeOfDay start;
  final TimeOfDay end;
  final int duration;
  final int price;
  final String metode;

  ScheduleEntry({
    required this.start,
    required this.end,
    required this.duration,
    required this.price,
    required this.metode,
  });
}
