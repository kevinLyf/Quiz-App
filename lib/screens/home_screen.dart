import 'package:flutter/material.dart';
import 'package:quiz/screens/quiz_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff189f8b),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 5),
              Column(
                children: [
                  Image.asset('assets/images/einstein.webp'),
                  const Text(
                    'With the questions you train your brain and improve your memory and concentration.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const QuizPage(),
                  ),
                ),
                child: Container(
                  width: double.maxFinite,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xff42b4a5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      'START',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
