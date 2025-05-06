import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final String asalUniversitas;
  final String sertifikasi;
  final String noHp;
  final String email;

  const ProfileInfo({
    Key? key,
    required this.asalUniversitas,
    required this.sertifikasi,
    required this.noHp,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInfoRow('Asal Universitas', asalUniversitas),
        SizedBox(height: 8),
        _buildInfoRow('Sertifikasi', sertifikasi),
        SizedBox(height: 8),
        _buildInfoRow('No. Hp', noHp),
        SizedBox(height: 8),
        _buildInfoRow('Email', email),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Text(':', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(width: 8),
        Expanded(flex: 5, child: Text(value, style: TextStyle(fontSize: 16))),
      ],
    );
  }
}

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Informasi Profil')),
      body: ProfileInfo(
        asalUniversitas: 'Politeknik Negeri Batam',
        sertifikasi: 'Database Mysql',
        noHp: '0811222333',
        email: 'Wibowo@gmail.com',
      ),
    );
  }
}
