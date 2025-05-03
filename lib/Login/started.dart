import 'package:flutter/material.dart';

class StartedScreen extends StatefulWidget {
  @override
  _StartedScreenState createState() => _StartedScreenState();
}

class _StartedScreenState extends State<StartedScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'image': 'assets/images/get_started_.png',
      'title': 'Find a Great Tutor or Be One!',
      'description':
          'Temukan tutor terbaik untuk kebutuhan belajarmu, atau jadi tutor dan bantu orang lain berkembang.',
    },
    {
      'image': 'assets/images/get_started1.png',
      'title': 'One App, Countless Opportunities',
      'description':
          'Belajar dan mengajar dalam satu aplikasi praktis. Semua bisa dimulai dari sini!',
    },
    {
      'image': 'assets/images/get_started2.png',
      'title': 'Chat with reliable tutor, without hassle.',
      'description':
          'Langsung ngobrol dengan tutor andalanmu, tanpa ribet dan tanpa harus pindah platform.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TITLE & DESCRIPTION DI ATAS
                      Text(
                        _slides[index]['title']!,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        _slides[index]['description']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),

                      Image.asset(
                        _slides[index]['image']!,
                        height: 300,
                        width: 300,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: _currentPage == index ? 12 : 8,
                height: _currentPage == index ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentPage == index
                          ? Colors.purple
                          : const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_currentPage == _slides.length - 1) {
                Navigator.pushReplacementNamed(context, '/login');
              } else {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7C4DFF),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              foregroundColor: Colors.white,
            ),
            child: Text(
              _currentPage == _slides.length - 1 ? 'Get Started' : 'Next',
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
