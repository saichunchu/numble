import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../core/constants.dart';
import '../core/game_layout.dart';

class KeyButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const KeyButton({super.key, required this.label, required this.onTap});

  Color getColor(TileState? state) {
    switch (state) {
      case TileState.correct:
        return const Color(0xFF6AAA64);
      case TileState.present:
        return const Color(0xFFC9B458);
      case TileState.absent:
        return const Color(0xFF787C7E);
      default:
        return const Color(0xFF818384);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final state = provider.keyStates[label];
    final layout = GameLayout.of(context);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: getColor(state),
            minimumSize: Size(0, layout.keyHeight),
            padding: EdgeInsets.zero,
          ),
          onPressed: onTap,
          child: Text(
            label,
            style: TextStyle(
              fontSize: layout.keyFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}