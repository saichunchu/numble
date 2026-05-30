import '../core/constants.dart';

List<TileState> evaluateGuess(String guess, String target) {
  List<TileState> result =
      List.filled(wordLength, TileState.absent);

  List<bool> used = List.filled(wordLength, false);

  // Step 1: correct positions
  for (int i = 0; i < wordLength; i++) {
    if (guess[i] == target[i]) {
      result[i] = TileState.correct;
      used[i] = true;
    }
  }

  // Step 2: present (wrong position)
  for (int i = 0; i < wordLength; i++) {
    if (result[i] == TileState.correct) continue;

    for (int j = 0; j < wordLength; j++) {
      if (!used[j] && guess[i] == target[j]) {
        result[i] = TileState.present;
        used[j] = true;
        break;
      }
    }
  }

  return result;
}