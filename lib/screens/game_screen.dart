import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

import '../providers/game_provider.dart';
import '../widgets/grid.dart';
import '../widgets/keyboard.dart';
import '../widgets/premium_background.dart';
import '../widgets/premium_button.dart';
import '../core/game_layout.dart';
import '../core/app_motion.dart';
import '../core/app_theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ConfettiController _confettiController;
  bool _celebratedWin = false;

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

  BoxConstraints _playAreaConstraints(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final padding = MediaQuery.paddingOf(context);
    return BoxConstraints(
      maxWidth: constraints.maxWidth,
      maxHeight: constraints.maxHeight - padding.bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);

    if (provider.isWon && !_celebratedWin) {
      _celebratedWin = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _confettiController.play();
      });
    } else if (!provider.isGameOver) {
      _celebratedWin = false;
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: PremiumIconButton(
            icon: Icons.arrow_back_rounded,
            tooltip: 'Back',
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) =>
              AppTheme.titleGradient.createShader(bounds),
          child: Text(
            'NUMBLE',
            style: AppTheme.displayMedium(context).copyWith(
              fontSize: MediaQuery.sizeOf(context).width > 600 ? 24 : 22,
              color: Colors.white,
              letterSpacing: 3,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PremiumIconButton(
              icon: Icons.refresh_rounded,
              tooltip: 'New game',
              onPressed: () {
                provider.startGame();
                _confettiController.stop();
                _celebratedWin = false;
              },
            ),
          ),
        ],
      ),
      body: PremiumBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final playArea =
                _playAreaConstraints(context, constraints);
            final bodyLayout = GameLayoutData.fromConstraints(
              playArea,
              wordLength: provider.wordLength,
              maxAttempts: provider.maxAttempts,
            );

            return GameLayout(
              data: bodyLayout,
              child: Stack(
                children: [
                  SafeArea(
                    top: false,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: bodyLayout.maxContentWidth,
                        ),
                        child: bodyLayout.useScroll
                            ? SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: _GameContent(provider: provider),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: SizedBox(
                                  height: playArea.maxHeight,
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
                      emissionFrequency: 0.03,
                      numberOfParticles: 16,
                      gravity: 0.3,
                      colors: const [
                        AppColors.emerald,
                        AppColors.gold,
                        AppColors.amethyst,
                        AppColors.coral,
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
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
    final config = provider.config;

    return Column(
      mainAxisSize:
          layout.useScroll ? MainAxisSize.min : MainAxisSize.max,
      children: [
        SizedBox(height: layout.useScroll ? 8 : 10),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.pin_outlined,
                size: 15,
                color: AppColors.amethyst.withValues(alpha: 0.9),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Guess the ${config.wordLength}-digit number',
                  style: AppTheme.label(context).copyWith(
                    color: AppColors.textSecondary,
                    fontSize: layout.subtitleFontSize,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: layout.useScroll ? 12 : 16),

        _AdaptiveGridPanel(
          wordLength: config.wordLength,
          maxAttempts: config.maxAttempts,
          useExpanded: !layout.useScroll,
        ),

        const SizedBox(height: 6),

        AnimatedSwitcher(
          duration: AppMotion.medium,
          switchInCurve: AppMotion.enter,
          switchOutCurve: AppMotion.exit,
          transitionBuilder: AppMotion.scaleFadeTransition,
          child: provider.isWon
              ? _ResultBanner(
                  key: const ValueKey('win'),
                  icon: Icons.emoji_events_rounded,
                  text: 'Brilliant!',
                  color: AppColors.emerald,
                  fontSize: layout.resultFontSize,
                )
              : provider.isGameOver
                  ? _ResultBanner(
                      key: const ValueKey('lose'),
                      icon: Icons.lightbulb_outline_rounded,
                      text: 'Answer: ${provider.target}',
                      color: AppColors.coral,
                      fontSize: layout.resultFontSize * 0.9,
                    )
                  : const SizedBox.shrink(key: ValueKey('idle')),
        ),

        SizedBox(height: layout.useScroll ? 6 : 8),
        const Keyboard(),
        SizedBox(height: layout.useScroll ? 12 : 16),
      ],
    );
  }
}

/// Grid panel that scales tiles to fit available space (fixes RenderFlex overflow).
class _AdaptiveGridPanel extends StatelessWidget {
  final int wordLength;
  final int maxAttempts;
  final bool useExpanded;

  const _AdaptiveGridPanel({
    required this.wordLength,
    required this.maxAttempts,
    required this.useExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final layout = GameLayout.of(context);

    final panel = LayoutBuilder(
      builder: (context, constraints) {
        final fitted = layout.fittedForPanel(
          constraints,
          wordLength: wordLength,
          maxAttempts: maxAttempts,
        );

        return GameLayout(
          data: fitted,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: AppTheme.glassCard(radius: 18),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: wordLength * (fitted.tileSize + fitted.tileMargin * 2),
                  height:
                      maxAttempts * (fitted.tileSize + fitted.tileMargin * 2),
                  child: const GridWidget(),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (useExpanded) {
      return Expanded(child: panel);
    }

    return SizedBox(
      height: layout.gridPanelHeight,
      child: panel,
    );
  }
}

class _ResultBanner extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final double fontSize;

  const _ResultBanner({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.medium,
      curve: AppMotion.enter,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.85 + value * 0.15,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: fontSize * 1.1),
            const SizedBox(width: 10),
            Text(
              text,
              style: AppTheme.title(context).copyWith(
                color: color,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
