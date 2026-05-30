import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../core/constants.dart';
import '../core/game_layout.dart';

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

class _KeyButtonState extends State<KeyButton> {
  bool _pressed = false;

  Color _stateColor(TileState? state) {
    switch (state) {
      case TileState.correct:
        return const Color(0xFF6AAA64);
      case TileState.present:
        return const Color(0xFFC9B458);
      case TileState.absent:
        return const Color(0xFF787C7E);
      default:
        return const Color(0xFF565758);
    }
  }

  Color _baseColor(TileState? state) {
    switch (widget.variant) {
      case KeyButtonVariant.submit:
        return const Color(0xFF538D4E);
      case KeyButtonVariant.delete:
        return const Color(0xFF3A3A3C);
      case KeyButtonVariant.digit:
        return _stateColor(state);
    }
  }

  Color _shadowColor(TileState? state) {
    switch (widget.variant) {
      case KeyButtonVariant.submit:
        return const Color(0xFF3D6B39);
      case KeyButtonVariant.delete:
        return const Color(0xFF242426);
      case KeyButtonVariant.digit:
        if (state != null) {
          switch (state) {
            case TileState.correct:
              return const Color(0xFF4A8F47);
            case TileState.present:
              return const Color(0xFF9A8A3F);
            case TileState.absent:
              return const Color(0xFF5A5E60);
            case TileState.empty:
              return const Color(0xFF424242);
          }
        }
        return const Color(0xFF424242);
    }
  }

  void _handleTapDown(TapDownDetails _) => setState(() => _pressed = true);

  void _handleTapUp(TapUpDetails _) => setState(() => _pressed = false);

  void _handleTapCancel() => setState(() => _pressed = false);

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final state =
        widget.variant == KeyButtonVariant.digit && widget.label != null
            ? provider.keyStates[widget.label!]
            : null;
    final layout = GameLayout.of(context);
    final borderRadius = (layout.keyHeight * 0.14).clamp(5.0, 9.0);
    final baseColor = _baseColor(state);
    final shadowColor = _shadowColor(state);

    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: EdgeInsets.all(layout.keyPadding),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: _handleTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            curve: Curves.easeOut,
            height: layout.keyHeight,
            transform: Matrix4.translationValues(0, _pressed ? 2 : 0, 0),
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: _pressed
                  ? []
                  : [
                      BoxShadow(
                        color: shadowColor,
                        offset: const Offset(0, 3),
                        blurRadius: 0,
                      ),
                    ],
            ),
            child: Center(
              child: widget.icon != null
                  ? Icon(
                      widget.icon,
                      color: Colors.white,
                      size: layout.keyFontSize * 1.35,
                    )
                  : Text(
                      widget.label!,
                      style: TextStyle(
                        fontSize: layout.keyFontSize,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
