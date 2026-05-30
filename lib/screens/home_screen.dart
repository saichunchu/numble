import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/difficulty.dart';
import '../providers/game_provider.dart';
import '../widgets/premium_background.dart';
import '../widgets/premium_button.dart';
import '../core/page_transitions.dart';
import '../core/app_motion.dart';
import 'game_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PremiumBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWide ? 480 : 500),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: isWide ? 48 : 32),

                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: AppTheme.accentGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.amethyst
                                      .withValues(alpha: 0.4),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.grid_3x3_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),

                          const SizedBox(height: 28),

                          ShaderMask(
                            shaderCallback: (bounds) =>
                                AppTheme.titleGradient.createShader(bounds),
                            child: Text(
                              'NUMBLE',
                              style: AppTheme.displayLarge(context).copyWith(
                                fontSize: isWide ? 52 : 44,
                                color: Colors.white,
                                letterSpacing: 6,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'Find the Num',
                            style: AppTheme.headline(context).copyWith(
                              fontSize: 20,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.psychology_outlined,
                                size: 16,
                                color:
                                    AppColors.amethyst.withValues(alpha: 0.8),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Train your brain with number puzzles',
                                  style: AppTheme.body(context),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: isWide ? 48 : 36),

                          const _DifficultyPicker(),

                          SizedBox(height: isWide ? 40 : 32),

                          Consumer<GameProvider>(
                            builder: (context, provider, _) {
                              final config = provider.config;
                              return Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                alignment: WrapAlignment.center,
                                children: [
                                  _FeatureChip(
                                    icon: Icons.bolt_rounded,
                                    label: '${config.maxAttempts} Attempts',
                                    color: AppColors.gold,
                                  ),
                                  _FeatureChip(
                                    icon: Icons.tag_rounded,
                                    label: '${config.wordLength} Digits',
                                    color: AppColors.emerald,
                                  ),
                                  const _FeatureChip(
                                    icon: Icons.insights_rounded,
                                    label: 'Track Stats',
                                    color: AppColors.amethyst,
                                  ),
                                ],
                              );
                            },
                          ),

                          SizedBox(height: isWide ? 40 : 32),

                          PremiumButton(
                            label: 'Start Game',
                            icon: Icons.play_arrow_rounded,
                            onPressed: () {
                            Navigator.push(
                              context,
                              SmoothPageRoute(page: const GameScreen()),
                            );
                            },
                          ),

                          const SizedBox(height: 12),

                          PremiumTextButton(
                            label: 'View Profile',
                            icon: Icons.person_outline_rounded,
                            onPressed: () {
                              Navigator.push(
                                context,
                                SmoothPageRoute(
                                  page: const ProfileScreen(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DifficultyPicker extends StatelessWidget {
  const _DifficultyPicker();

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                'Select Difficulty',
                style: AppTheme.label(context).copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1,
                ),
              ),
            ),
            ...DifficultyConfig.all.map((config) {
              final selected = provider.difficulty == config.level;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _DifficultyTile(
                  config: config,
                  selected: selected,
                  onTap: () => provider.setDifficulty(config.level),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _DifficultyTile extends StatelessWidget {
  final DifficultyConfig config;
  final bool selected;
  final VoidCallback onTap;

  const _DifficultyTile({
    required this.config,
    required this.selected,
    required this.onTap,
  });

  Color get _accent {
    return switch (config.level) {
      // GameDifficulty.easy => AppColors.emerald,
      GameDifficulty.medium => AppColors.amethyst,
      GameDifficulty.hard => AppColors.gold,
      GameDifficulty.expert => AppColors.coral,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.medium,
      curve: AppMotion.standard,
      decoration: BoxDecoration(
        color: selected
            ? _accent.withValues(alpha: 0.12)
            : AppColors.surfaceElevated.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected
              ? _accent.withValues(alpha: 0.5)
              : AppColors.border.withValues(alpha: 0.4),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: AppMotion.medium,
                  curve: AppMotion.standard,
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _accent.withValues(alpha: selected ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(config.icon, size: 18, color: _accent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(config.label, style: AppTheme.title(context)),
                      Text(
                        config.description,
                        style: AppTheme.body(context).copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                AnimatedScale(
                  scale: selected ? 1.0 : 0.0,
                  duration: AppMotion.medium,
                  curve: AppMotion.pop,
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: _accent,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FeatureChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTheme.label(context).copyWith(
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
