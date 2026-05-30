import '../core/constants.dart';

List<TileState> evaluateGuess(String guess, String target) {
  final length = target.length;
  final result = List.filled(length, TileState.absent);
  final used = List.filled(length, false);

  for (int i = 0; i < length; i++) {
    if (guess[i] == target[i]) {
      result[i] = TileState.correct;
      used[i] = true;
    }
  }

  for (int i = 0; i < length; i++) {
    if (result[i] == TileState.correct) continue;

    for (int j = 0; j < length; j++) {
      if (!used[j] && guess[i] == target[j]) {
        result[i] = TileState.present;
        used[j] = true;
        break;
      }
    }
  }

  return result;
}
