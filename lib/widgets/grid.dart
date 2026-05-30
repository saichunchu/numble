import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../core/constants.dart';
import '../core/app_motion.dart';
import 'tile.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final wordLength = provider.wordLength;
    final maxAttempts = provider.maxAttempts;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxAttempts, (row) {
        return _GridRow(
          key: ValueKey('grid-row-$row'),
          row: row,
          wordLength: wordLength,
        );
      }),
    );
  }
}

class _GridRow extends StatelessWidget {
  final int row;
  final int wordLength;

  const _GridRow({
    super.key,
    required this.row,
    required this.wordLength,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<GameProvider, _RowData>(
      selector: (_, p) => _RowData.from(p, row),
      builder: (context, data, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(wordLength, (col) {
            return _GridTile(
              key: ValueKey('tile-$row-$col'),
              row: row,
              col: col,
              data: data,
            );
          }),
        );
      },
    );
  }
}

class _RowData {
  final String? guessValue;
  final List<TileState>? guessStates;
  final String currentInput;
  final int activeRow;

  const _RowData({
    required this.guessValue,
    required this.guessStates,
    required this.currentInput,
    required this.activeRow,
  });

  factory _RowData.from(GameProvider p, int row) {
    if (row < p.guesses.length) {
      final g = p.guesses[row];
      return _RowData(
        guessValue: g.value,
        guessStates: g.states,
        currentInput: p.currentInput,
        activeRow: p.guesses.length,
      );
    }
    return _RowData(
      guessValue: null,
      guessStates: null,
      currentInput: p.currentInput,
      activeRow: p.guesses.length,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! _RowData) return false;
    return guessValue == other.guessValue &&
        listEquals(guessStates, other.guessStates) &&
        currentInput == other.currentInput &&
        activeRow == other.activeRow;
  }

  @override
  int get hashCode =>
      Object.hash(guessValue, guessStates, currentInput, activeRow);
}

class _GridTile extends StatelessWidget {
  final int row;
  final int col;
  final _RowData data;

  const _GridTile({
    super.key,
    required this.row,
    required this.col,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.guessValue != null && data.guessStates != null) {
      return Tile(
        digit: data.guessValue![col],
        state: data.guessStates![col],
        reveal: true,
        flipDelayMs: col * AppMotion.staggerStep.inMilliseconds,
      );
    }

    if (row == data.activeRow && col < data.currentInput.length) {
      return Tile(
        digit: data.currentInput[col],
        state: TileState.empty,
      );
    }

    return const Tile(digit: '', state: TileState.empty);
  }
}
