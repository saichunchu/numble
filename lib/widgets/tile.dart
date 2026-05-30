import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/game_layout.dart';
import 'dart:math';

class Tile extends StatefulWidget {
  final String digit;
  final TileState state;
  final bool reveal;

  const Tile({
    super.key,
    required this.digit,
    required this.state,
    this.reveal = false,
  });

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animation =
        Tween<double>(begin: 0, end: 1).animate(controller);

    if (widget.reveal) {
      controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant Tile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.reveal && !oldWidget.reveal) {
      controller.forward();
    }
  }

  Color getColor() {
    switch (widget.state) {
      case TileState.correct:
        return const Color(0xFF6AAA64);
      case TileState.present:
        return const Color(0xFFC9B458);
      case TileState.absent:
        return const Color(0xFF787C7E);
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final layout = GameLayout.of(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final angle = animation.value * pi;

        final isFront = angle < pi / 2;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(angle),
          child: Container(
            margin: EdgeInsets.all(layout.tileMargin),
            width: layout.tileSize,
            height: layout.tileSize,
            decoration: BoxDecoration(
              color: isFront ? Colors.transparent : getColor(),
              border: Border.all(
                color: const Color(0xFF3A3A3C),
                width: 2,
              ),
            ),
            child: Center(
              child: isFront
                  ? Text(
                      widget.digit,
                      style: TextStyle(
                        fontSize: layout.tileFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationX(pi),
                      child: Text(
                        widget.digit,
                        style: TextStyle(
                          fontSize: layout.tileFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}