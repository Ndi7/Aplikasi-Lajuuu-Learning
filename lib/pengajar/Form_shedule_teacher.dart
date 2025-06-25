import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:aplikasi_lajuuu_learning/pengajar/Harga_teacher.dart';
import '../widget/headersmall_bar.dart';

class TimeAvailabilityScreen extends StatefulWidget {
  const TimeAvailabilityScreen({Key? key}) : super(key: key);

  @override
  _TimeAvailabilityScreenState createState() => _TimeAvailabilityScreenState();
}

class _TimeAvailabilityScreenState extends State<TimeAvailabilityScreen> {
  List<TimeRange> timeRanges = [];

  TimeOfDay selectedStartTime = const TimeOfDay(hour: 09, minute: 00);
  TimeOfDay selectedEndTime = const TimeOfDay(hour: 10, minute: 00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSmallBar(
        title: 'Pilih Jam Ketersediaan',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTimePickerRow(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Tambah Waktu',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _addTimeRange,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7C4DFF),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  timeRanges.isEmpty
                      ? const Center(
                        child: Text('Belum ada waktu ditambahkan.'),
                      )
                      : ListView.builder(
                        itemCount: timeRanges.length,
                        itemBuilder: (context, index) {
                          final range = timeRanges[index];
                          return ListTile(
                            title: Text(
                              '${_formatTime(range.start)} - ${_formatTime(range.end)}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  timeRanges.removeAt(index);
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
                backgroundColor: Color(0xFF7C4DFF),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Simpan dan Lanjutkan',
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

  void _addTimeRange() {
    final startMinutes = selectedStartTime.hour * 60 + selectedStartTime.minute;
    final endMinutes = selectedEndTime.hour * 60 + selectedEndTime.minute;

    if (startMinutes >= endMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Waktu mulai harus sebelum waktu selesai."),
        ),
      );
      return;
    }

    setState(() {
      timeRanges.add(TimeRange(start: selectedStartTime, end: selectedEndTime));
    });
  }

  Future<void> _saveToFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final slotsRef = FirebaseFirestore.instance
        .collection('pengajar')
        .doc(uid)
        .collection('time_slots');

    for (var range in timeRanges) {
      await slotsRef.add({
        'startTime': _formatTime(range.start),
        'endTime': _formatTime(range.end),
        'available': true,
      });
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TambahJadwalScreen()),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class TimeRange {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeRange({required this.start, required this.end});
}
