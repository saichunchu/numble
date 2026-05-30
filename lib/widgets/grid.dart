import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../core/constants.dart';
import 'tile.dart';

class GridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxAttempts, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(wordLength, (col) {
            if (row < provider.guesses.length) {
              final guess = provider.guesses[row];

              return Tile(
                digit: guess.value[col],
                state: guess.states[col],
                reveal: true,
              );
            } else if (row == provider.guesses.length &&
                col < provider.currentInput.length) {
              return Tile(
                digit: provider.currentInput[col],
                state: TileState.empty,
              );
            } else {
              return const Tile(digit: "", state: TileState.empty);
            }
          }),
        );
      }),
    );
  }
}