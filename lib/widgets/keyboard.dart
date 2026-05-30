import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../core/game_layout.dart';
import '../core/app_theme.dart';
import 'key_button.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<GameProvider>();
    final layout = GameLayout.of(context);

    return RepaintBoundary(
      child: SizedBox(
        height: layout.keyboardHeight,
        width: layout.maxContentWidth,
        child: Container(
        decoration: AppTheme.glassCard(radius: 18).copyWith(
          boxShadow: [
            BoxShadow(
              color: AppColors.amethyst.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(
          layout.keyPadding + 4,
          layout.keyPadding + 8,
          layout.keyPadding + 4,
          layout.keyPadding + 4,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _KeyRow(labels: const ['1', '2', '3'], onTap: provider.addDigit),
            _KeyRow(labels: const ['4', '5', '6'], onTap: provider.addDigit),
            _KeyRow(labels: const ['7', '8', '9'], onTap: provider.addDigit),
            Row(
              children: [
                KeyButton(
                  label: '0',
                  onTap: () => provider.addDigit('0'),
                ),
                KeyButton(
                  icon: Icons.backspace_outlined,
                  onTap: provider.removeDigit,
                  flex: 2,
                  variant: KeyButtonVariant.delete,
                ),
                KeyButton(
                  icon: Icons.check_rounded,
                  onTap: provider.submitGuess,
                  flex: 2,
                  variant: KeyButtonVariant.submit,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class _KeyRow extends StatelessWidget {
  final List<String> labels;
  final void Function(String) onTap;

  const _KeyRow({required this.labels, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: labels
          .map((label) => KeyButton(
                label: label,
                onTap: () => onTap(label),
              ))
          .toList(),
    );
  }
}
