import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/utils.dart';
import '../models/guess_model.dart';
import '../services/game_service.dart';
import '../services/storage_service.dart';

class GameProvider extends ChangeNotifier {
  late String target;
  List<Guess> guesses = [];
  String currentInput = "";

  Map<String, TileState> keyStates = {};

  int gamesPlayed = 0;
  int wins = 0;
  int streak = 0;
  int maxStreak = 0;

  GameProvider() {
    startGame();
    loadStats();
  }

  bool get isWon =>
      guesses.isNotEmpty && guesses.last.value == target;

  bool get isGameOver =>
      isWon || guesses.length >= maxAttempts;

  void startGame() {
    target = generateTarget();
    guesses.clear();
    currentInput = "";
    keyStates.clear();
    notifyListeners();
  }

  void addDigit(String digit) {
    if (isGameOver) return;
    if (currentInput.length < wordLength) {
      currentInput += digit;
      notifyListeners();
    }
  }

  void removeDigit() {
    if (isGameOver) return;
    if (currentInput.isNotEmpty) {
      currentInput =
          currentInput.substring(0, currentInput.length - 1);
      notifyListeners();
    }
  }

  void submitGuess() async {
    if (isGameOver) return;
    if (currentInput.length != wordLength) return;

    final states = evaluateGuess(currentInput, target);

    for (int i = 0; i < wordLength; i++) {
      String digit = currentInput[i];

      if (!keyStates.containsKey(digit) ||
          states[i] == TileState.correct ||
          (states[i] == TileState.present &&
              keyStates[digit] != TileState.correct)) {
        keyStates[digit] = states[i];
      }
    }

    guesses.add(Guess(value: currentInput, states: states));
    currentInput = "";

    if (isGameOver) {
      await updateStats();
    }

    notifyListeners();
  }

  Future<void> loadStats() async {
    final data = await StorageService.loadStats();

    gamesPlayed = data['games']!;
    wins = data['wins']!;
    streak = data['streak']!;
    maxStreak = data['maxStreak']!;
    notifyListeners();
  }

  Future<void> updateStats() async {
    gamesPlayed++;

    if (isWon) {
      wins++;
      streak++;
      if (streak > maxStreak) maxStreak = streak;
    } else {
      streak = 0;
    }

    await StorageService.saveStats(
        gamesPlayed, wins, streak, maxStreak);
  }
}