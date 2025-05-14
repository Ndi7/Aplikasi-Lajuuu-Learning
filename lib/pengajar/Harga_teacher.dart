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
      home: TambahJadwalScreen(),
    );
  }
}

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
    _addScheduleField(); // Tambah default satu baris
  }

  void _addScheduleField() {
    setState(() {
      scheduleList.add({
        'duration': TextEditingController(),
        'price': TextEditingController(),
      });
    });
  }

  void _saveSchedule() {
    // Aksi penyimpanan
    for (var item in scheduleList) {
      print("Durasi: ${item['duration']!.text}, Harga: ${item['price']!.text}");
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
      appBar: AppBar(
        title: const Text(
          'Tambah jadwal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                              hintText: 'Masukkan menit',
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
                              hintText: 'Masukkan harga',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (index == scheduleList.length - 1)
                          IconButton(
                            onPressed: _addScheduleField,
                            icon: const Icon(Icons.add, color: Colors.grey),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _saveSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
