import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TimeAvailabilityScreen(),
    );
  }
}

class TimeRange {
  TimeOfDay start;
  TimeOfDay end;

  TimeRange({required this.start, required this.end});
}

class TimeAvailabilityScreen extends StatefulWidget {
  const TimeAvailabilityScreen({super.key});

  @override
  State<TimeAvailabilityScreen> createState() => _TimeAvailabilityScreenState();
}

class _TimeAvailabilityScreenState extends State<TimeAvailabilityScreen> {
  List<TimeRange> timeRanges = [
    TimeRange(
      start: const TimeOfDay(hour: 20, minute: 0),
      end: const TimeOfDay(hour: 21, minute: 0),
    ),
  ];

  Future<void> _selectTime(
    BuildContext context,
    int index,
    bool isStartTime,
  ) async {
    final TimeOfDay initial =
        isStartTime ? timeRanges[index].start : timeRanges[index].end;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          timeRanges[index].start = picked;
        } else {
          timeRanges[index].end = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _addTimeRange() {
    setState(() {
      timeRanges.add(
        TimeRange(
          start: const TimeOfDay(hour: 8, minute: 0),
          end: const TimeOfDay(hour: 9, minute: 0),
        ),
      );
    });
  }

  void _nextAction() {
    // Aksi saat tombol Selanjutnya ditekan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah waktu ketersediaan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          24,
        ), // Jarak bawah ditambahkan
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: timeRanges.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Dari "),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _selectTime(context, index, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: Text(_formatTime(timeRanges[index].start)),
                        ),
                        const SizedBox(width: 16),
                        const Text("Sampai "),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _selectTime(context, index, false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: Text(_formatTime(timeRanges[index].end)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bagian bawah tapi tidak menempel ke ujung layar
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _addTimeRange,
                      icon: const Icon(Icons.add, color: Colors.deepPurple),
                      label: const Text(
                        "Tambah Waktu",
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _nextAction,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.deepPurple,
                        ),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                      child: const Text(
                        'Selanjutnya',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
