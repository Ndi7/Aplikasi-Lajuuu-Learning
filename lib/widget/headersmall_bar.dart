import 'package:flutter/material.dart';

class HeaderSmallBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // Teks judul yang akan tampil di header
  final VoidCallback? onBack;

  const HeaderSmallBar({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        height: 120,
        color: const Color(0xFF7C4DFF),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onBack ?? () => Navigator.maybePop(context),
                child: const Icon(
                  Icons.chevron_left, // Ikon back
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title, // Judul dinamis sesuai halaman
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 20.0;

    final path = Path();
    path.lineTo(0, size.height - 50 - radius);

    path.quadraticBezierTo(0, size.height - 50, radius, size.height - 45);

    path.lineTo(size.width / 2, size.height - 15);

    path.lineTo(size.width - radius, size.height - 50);

    path.quadraticBezierTo(
      size.width,
      size.height - 55,
      size.width,
      size.height - 55 - radius,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
