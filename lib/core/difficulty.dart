import 'package:flutter/material.dart';

enum GameDifficulty { medium, hard, expert }

class DifficultyConfig {
  final GameDifficulty level;
  final String label;
  final String description;
  final int wordLength;
  final int maxAttempts;
  final IconData icon;

  const DifficultyConfig({
    required this.level,
    required this.label,
    required this.description,
    required this.wordLength,
    required this.maxAttempts,
    required this.icon,
  });

  // static const easy = DifficultyConfig(
  //   level: GameDifficulty.easy,
  //   label: 'Easy',
  //   description: '4 digits · 8 attempts',
  //   wordLength: 4,
  //   maxAttempts: 8,
  //   icon: Icons.sentiment_satisfied_alt_rounded,
  // );

  static const medium = DifficultyConfig(
    level: GameDifficulty.medium,
    label: 'Medium',
    description: '5 digits · 6 attempts',
    wordLength: 5,
    maxAttempts: 6,
    icon: Icons.balance_rounded,
  );

  static const hard = DifficultyConfig(
    level: GameDifficulty.hard,
    label: 'Hard',
    description: '6 digits · 5 attempts',
    wordLength: 6,
    maxAttempts: 5,
    icon: Icons.local_fire_department_rounded,
  );

  static const expert = DifficultyConfig(
    level: GameDifficulty.expert,
    label: 'Expert',
    description: '6 digits · 4 attempts',
    wordLength: 6,
    maxAttempts: 4,
    icon: Icons.whatshot_rounded,
  );

  static DifficultyConfig forLevel(GameDifficulty level) {
    return switch (level) {
      // GameDifficulty.easy => easy,
      GameDifficulty.medium => medium,
      GameDifficulty.hard => hard,
      GameDifficulty.expert => expert,
    };
  }

  static const all = [medium, hard, expert];
}
