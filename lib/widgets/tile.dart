import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/game_layout.dart';
import '../core/app_theme.dart';
import '../core/app_motion.dart';
import 'dart:math';

class Tile extends StatefulWidget {
  final String digit;
  final TileState state;
  final bool reveal;
  final int flipDelayMs;

  const Tile({
    super.key,
    required this.digit,
    required this.state,
    this.reveal = false,
    this.flipDelayMs = 0,
  });

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _popController;
  late Animation<double> _flipAnimation;
  late Animation<double> _popAnimation;
  String _previousDigit = '';

  @override
  void initState() {
    super.initState();
    _previousDigit = widget.digit;

    _flipController = AnimationController(
      vsync: this,
      duration: AppMotion.flip,
    );
    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: AppMotion.flipCurve,
    );

    _popController = AnimationController(
      vsync: this,
      duration: AppMotion.fast,
    );
    _popAnimation = Tween<double>(begin: 1, end: 1.08).animate(
      CurvedAnimation(parent: _popController, curve: AppMotion.pop),
    );

    if (widget.reveal) {
      _scheduleFlip();
    }
  }

  void _scheduleFlip() {
    if (widget.flipDelayMs <= 0) {
      _flipController.forward();
      return;
    }
    Future.delayed(Duration(milliseconds: widget.flipDelayMs), () {
      if (mounted) _flipController.forward();
    });
  }

  @override
  void didUpdateWidget(covariant Tile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.reveal && !oldWidget.reveal) {
      _flipController.reset();
      _scheduleFlip();
    }

    if (widget.digit.isNotEmpty && _previousDigit.isEmpty && !widget.reveal) {
      _popController.forward(from: 0).then((_) {
        if (mounted) _popController.reverse();
      });
    }
    _previousDigit = widget.digit;
  }

  @override
  void dispose() {
    _flipController.dispose();
    _popController.dispose();
    super.dispose();
  }

  ({Color fill, Color shadow, Color border}) _colors() {
    switch (widget.state) {
      case TileState.correct:
        return (
          fill: AppColors.correct,
          shadow: AppColors.correctDark,
          border: AppColors.correct,
        );
      case TileState.present:
        return (
          fill: AppColors.present,
          shadow: AppColors.presentDark,
          border: AppColors.present,
        );
      case TileState.absent:
        return (
          fill: AppColors.absent,
          shadow: AppColors.absentDark,
          border: AppColors.absent,
        );
      default:
        return (
          fill: Colors.transparent,
          shadow: AppColors.border,
          border: AppColors.borderLight,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final layout = GameLayout.of(context);
    final colors = _colors();
    final radius = (layout.tileSize * 0.12).clamp(6.0, 10.0);
    final hasDigit = widget.digit.isNotEmpty;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_flipAnimation, _popAnimation]),
        builder: (context, child) {
          final angle = _flipAnimation.value * pi;
          final isFront = angle < pi / 2;
          final fillColor = isFront ? Colors.transparent : colors.fill;
          final popScale = widget.reveal ? 1.0 : _popAnimation.value;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(angle)
              ..scale(popScale, popScale, 1.0),
            child: Container(
              margin: EdgeInsets.all(layout.tileMargin),
              width: layout.tileSize,
              height: layout.tileSize,
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: hasDigit && isFront
                      ? AppColors.amethyst.withValues(alpha: 0.55)
                      : colors.border.withValues(alpha: isFront ? 0.7 : 1.0),
                  width: isFront ? 1.5 : 2,
                ),
                boxShadow: isFront
                    ? null
                    : [
                        BoxShadow(
                          color: colors.shadow.withValues(alpha: 0.45),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: isFront
                    ? AnimatedDefaultTextStyle(
                        duration: AppMotion.fast,
                        curve: AppMotion.standard,
                        style: AppTheme.tileDigit(layout.tileFontSize).copyWith(
                          color: hasDigit
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ),
                        child: Text(widget.digit),
                      )
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationX(pi),
                        child: Text(
                          widget.digit,
                          style: AppTheme.tileDigit(layout.tileFontSize),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
