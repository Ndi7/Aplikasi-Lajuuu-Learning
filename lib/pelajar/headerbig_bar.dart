import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        height: 200,
        color: Color(0xFF7C4DFF),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hi, Lajuuu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Mau belajar apa hari ini?',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 20.0;

    final path = Path();
    path.lineTo(0, size.height - 50 - radius);
    path.quadraticBezierTo(0, size.height - 50, radius, size.height - 45);
    path.lineTo(size.width / 2, size.height);
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
