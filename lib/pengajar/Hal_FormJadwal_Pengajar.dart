import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: FormJadwalPage()),
  );
}

class FormJadwalPage extends StatefulWidget {
  @override
  _FormJadwalPageState createState() => _FormJadwalPageState();
}

class JamRange {
  TimeOfDay? mulai;
  TimeOfDay? selesai;

  JamRange({this.mulai, this.selesai});
}

class _FormJadwalPageState extends State<FormJadwalPage> {
  String? selectedMode = 'Online';
  List<JamRange> jamList = [JamRange(), JamRange(), JamRange()];

  void tambahJam() {
    setState(() {
      jamList.add(JamRange());
    });
  }

  Future<void> pilihJamRange(int index) async {
    TimeOfDay? mulai = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (mulai != null) {
      TimeOfDay? selesai = await showTimePicker(
        context: context,
        initialTime: mulai,
      );

      if (selesai != null) {
        setState(() {
          jamList[index].mulai = mulai;
          jamList[index].selesai = selesai;
        });
      }
    }
  }

  String formatJam(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.Hm().format(dt); // e.g., 13:00
  }

  @override
  Widget build(BuildContext context) {
    Color purple = Color(0xFF7C4DFF);
    Color greenMatching = Color(0xFF4CAF50);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: purple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header dengan tombol kembali
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "FORM JADWAL",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Radio Button Mode
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<String>(
                        activeColor: Colors.white,
                        value: 'Online',
                        groupValue: selectedMode,
                        onChanged: (value) {
                          setState(() {
                            selectedMode = value;
                          });
                        },
                      ),
                      Text('Online', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 20),
                      Radio<String>(
                        activeColor: Colors.white,
                        value: 'Offline',
                        groupValue: selectedMode,
                        onChanged: (value) {
                          setState(() {
                            selectedMode = value;
                          });
                        },
                      ),
                      Text('Offline', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Jam",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ...List.generate(jamList.length, (index) {
                    JamRange jam = jamList[index];
                    String displayText;

                    if (jam.mulai != null && jam.selesai != null) {
                      displayText =
                          "${formatJam(jam.mulai!)} - ${formatJam(jam.selesai!)}";
                    } else {
                      displayText = "Masukkan Jam";
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: GestureDetector(
                        onTap: () => pilihJamRange(index),
                        child: Container(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            displayText,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  }),
                  GestureDetector(
                    onTap: tambahJam,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "+ Tambah Jam",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      print("Mode: $selectedMode");
                      jamList.forEach((jam) {
                        print(
                          (jam.mulai != null && jam.selesai != null)
                              ? "${formatJam(jam.mulai!)} - ${formatJam(jam.selesai!)}"
                              : "Belum dipilih",
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenMatching,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      "Selesai",
                      style: TextStyle(color: Colors.white),
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
}
