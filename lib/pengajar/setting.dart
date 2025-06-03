import 'package:flutter/material.dart';
import 'package:aplikasi_lajuuu_learning/pelajar/headersmall_bar.dart';
import 'edit_profil.dart';
import 'Page_info&bantuan_teacher.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PengaturanPage(),
    ),
  );
}

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  String _selectedLanguage = 'Indonesia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSmallBar(
        title: 'Pengaturan',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 70),
            Container(
              width: 330,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey, width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMenuItem(
                    "Edit Profil",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Bahasa",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  _buildLanguageOption("Indonesia"),
                  _buildLanguageOption("Inggris"),
                  const SizedBox(height: 24),
                  _buildMenuItem(
                    "Info",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoBantuanPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return RadioListTile<String>(
      contentPadding: EdgeInsets.zero,
      title: Text(
        language,
        style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
      ),
      value: language,
      groupValue: _selectedLanguage,
      activeColor: Colors.deepPurple,
      onChanged: (value) {
        setState(() {
          _selectedLanguage = value!;
        });
      },
    );
  }
}
