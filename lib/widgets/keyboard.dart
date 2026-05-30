import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'key_button.dart';

class Keyboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);

    return Column(
      children: [
        Row(children: ["1","2","3"].map((e) =>
          KeyButton(label: e, onTap: () => provider.addDigit(e))).toList()),

        Row(children: ["4","5","6"].map((e) =>
          KeyButton(label: e, onTap: () => provider.addDigit(e))).toList()),

        Row(children: ["7","8","9"].map((e) =>
          KeyButton(label: e, onTap: () => provider.addDigit(e))).toList()),

        Row(
          children: [
            KeyButton(label: "0", onTap: () => provider.addDigit("0")),
            KeyButton(label: "⌫", onTap: provider.removeDigit),
            KeyButton(label: "✔", onTap: provider.submitGuess),
          ],
        )
      ],
    );
  }
}