import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

import '../providers/game_provider.dart';
import '../widgets/grid.dart';
import '../widgets/keyboard.dart';
import '../core/game_layout.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  BoxConstraints _bodyConstraints(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return BoxConstraints(
      maxWidth: mediaQuery.size.width,
      maxHeight: mediaQuery.size.height -
          mediaQuery.padding.top -
          kToolbarHeight -
          mediaQuery.padding.bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final layout = GameLayoutData.fromConstraints(_bodyConstraints(context));

    if (provider.isWon) {
      _confettiController.play();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121213),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121213),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "NUMBLE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: layout.titleFontSize,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.startGame();
              _confettiController.stop();
            },
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bodyLayout = GameLayoutData.fromConstraints(constraints);

          return GameLayout(
            data: bodyLayout,
            child: Stack(
              children: [
                SafeArea(
                  top: false,
                  child: Center(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: bodyLayout.maxContentWidth),
                      child: bodyLayout.useScroll
                          ? SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: _GameContent(provider: provider),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: SizedBox(
                                height: constraints.maxHeight,
                                child: _GameContent(provider: provider),
                              ),
                            ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: pi / 2,
                    emissionFrequency: 0.05,
                    numberOfParticles: 20,
                    gravity: 0.3,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GameContent extends StatelessWidget {
  final GameProvider provider;

  const _GameContent({required this.provider});

  @override
  Widget build(BuildContext context) {
    final layout = GameLayout.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: layout.useScroll ? 8 : 10),
        Text(
          "Guess the 5-digit number",
          style: TextStyle(
            color: const Color(0xFFB0B0B0),
            fontSize: layout.subtitleFontSize,
          ),
        ),
        SizedBox(height: layout.useScroll ? 12 : 20),
        SizedBox(
          height: layout.gridHeight,
          child: Center(child: GridWidget()),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: provider.isWon
              ? Text(
                  "🎉 Brilliant!",
                  key: const ValueKey("win"),
                  style: TextStyle(
                    color: const Color(0xFF6AAA64),
                    fontSize: layout.resultFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : provider.isGameOver
                  ? Text(
                      "Answer: ${provider.target}",
                      key: const ValueKey("lose"),
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: layout.resultFontSize * 0.85,
                      ),
                    )
                  : const SizedBox.shrink(),
        ),
        SizedBox(height: layout.useScroll ? 8 : 10),
        Keyboard(),
        SizedBox(height: layout.useScroll ? 12 : 20),
      ],
    );
  }
}
