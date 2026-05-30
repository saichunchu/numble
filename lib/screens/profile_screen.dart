import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);

    double winRate = provider.gamesPlayed == 0
        ? 0
        : (provider.wins / provider.gamesPlayed) * 100;

    return Scaffold(
      backgroundColor: const Color(0xFF121213),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121213),
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// 👤 AVATAR
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 40),
            ),

            const SizedBox(height: 20),

            /// 📊 STATS
            Card(
              color: const Color(0xFF1E1E1E),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    statRow("Games Played", provider.gamesPlayed.toString()),
                    statRow("Wins", provider.wins.toString()),
                    statRow("Win Rate", "${winRate.toStringAsFixed(1)}%"),
                    statRow("Current Streak", provider.streak.toString()),
                    statRow("Max Streak", provider.maxStreak.toString()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}