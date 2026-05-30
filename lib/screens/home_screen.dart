import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121213),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          /// 🎯 APP TITLE
          const Text(
            "Find the Num 🔢",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 3,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Function your brain to find the number",
            style: TextStyle(color: Colors.grey),
          ),

          const Spacer(),

          /// ▶️ START BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6AAA64),
                minimumSize: const Size(double.infinity, 60),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => GameScreen()),
                );
              },
              child: const Text(
                "Start Game",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),

          const SizedBox(height: 15),

          /// 👤 PROFILE BUTTON
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ProfileScreen()),
              );
            },
            child: const Text(
              "View Profile",
              style: TextStyle(color: Colors.white70),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}