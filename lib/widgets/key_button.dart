import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../core/constants.dart';
import '../core/game_layout.dart';
import '../core/app_theme.dart';
import '../core/app_motion.dart';

enum KeyButtonVariant { digit, delete, submit }

class KeyButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final int flex;
  final KeyButtonVariant variant;

  const KeyButton({
    super.key,
    this.label,
    this.icon,
    required this.onTap,
    this.flex = 1,
    this.variant = KeyButtonVariant.digit,
  }) : assert(label != null || icon != null);

  @override
  State<KeyButton> createState() => _KeyButtonState();
}

class _KeyButtonState extends State<KeyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: AppMotion.instant,
    );
    _pressScale = Tween<double>(begin: 1, end: 0.94).animate(
      CurvedAnimation(parent: _pressController, curve: AppMotion.standard),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  ({Color fill, Color shadow}) _colors(TileState? state) {
    switch (widget.variant) {
      case KeyButtonVariant.submit:
        return (fill: AppColors.emeraldDark, shadow: const Color(0xFF065F46));
      case KeyButtonVariant.delete:
        return (fill: AppColors.keyAction, shadow: AppColors.keyActionShadow);
      case KeyButtonVariant.digit:
        switch (state) {
          case TileState.correct:
            return (fill: AppColors.correct, shadow: AppColors.correctDark);
          case TileState.present:
            return (fill: AppColors.present, shadow: AppColors.presentDark);
          case TileState.absent:
            return (fill: AppColors.absent, shadow: AppColors.absentDark);
          default:
            return (
              fill: AppColors.keyDefault,
              shadow: AppColors.keyDefaultShadow,
            );
        }
    }
  }

  void _handleTapDown(TapDownDetails _) => _pressController.forward();
  void _handleTapUp(TapUpDetails _) => _pressController.reverse();
  void _handleTapCancel() => _pressController.reverse();

  void _handleTap() {
    HapticFeedback.selectionClick();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final layout = GameLayout.of(context);
    final borderRadius = (layout.keyHeight * 0.16).clamp(6.0, 10.0);

    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: EdgeInsets.all(layout.keyPadding),
        child: widget.variant == KeyButtonVariant.digit && widget.label != null
            ? Selector<GameProvider, TileState?>(
                selector: (_, p) => p.keyStates[widget.label!],
                builder: (context, state, _) =>
                    _buildKey(layout, borderRadius, state),
              )
            : _buildKey(layout, borderRadius, null),
      ),
    );
  }

  Widget _buildKey(
    GameLayoutData layout,
    double borderRadius,
    TileState? state,
  ) {
    final colors = _colors(state);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _pressScale,
        child: AnimatedContainer(
          duration: AppMotion.medium,
          curve: AppMotion.standard,
          height: layout.keyHeight,
          decoration: BoxDecoration(
            gradient: widget.variant == KeyButtonVariant.submit
                ? AppTheme.primaryGradient
                : null,
            color:
                widget.variant == KeyButtonVariant.submit ? null : colors.fill,
            borderRadius: BorderRadius.circular(borderRadius),
            border: widget.variant == KeyButtonVariant.digit && state == null
                ? Border.all(
                    color: AppColors.border.withValues(alpha: 0.5),
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(
                  alpha: _pressController.isAnimating ? 0.2 : 0.9,
                ),
                offset: Offset(0, _pressController.value > 0 ? 1 : 3),
                blurRadius:
                    widget.variant == KeyButtonVariant.submit ? 6 : 0,
              ),
            ],
          ),
          child: Center(
            child: widget.icon != null
                ? Icon(
                    widget.icon,
                    color: AppColors.textPrimary,
                    size: layout.keyFontSize * 1.3,
                  )
                : Text(
                    widget.label!,
                    style: AppTheme.keyLabel(layout.keyFontSize),
                  ),
          ),
        ),
      ),
    );
  }
}
