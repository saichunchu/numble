import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveStats(
      int games, int wins, int streak, int maxStreak) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('games', games);
    await prefs.setInt('wins', wins);
    await prefs.setInt('streak', streak);
    await prefs.setInt('maxStreak', maxStreak);
  }

  static Future<Map<String, int>> loadStats() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'games': prefs.getInt('games') ?? 0,
      'wins': prefs.getInt('wins') ?? 0,
      'streak': prefs.getInt('streak') ?? 0,
      'maxStreak': prefs.getInt('maxStreak') ?? 0,
    };
  }
}