import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../core/app_theme.dart';
import '../widgets/premium_background.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);

    final winRate = provider.gamesPlayed == 0
        ? 0.0
        : (provider.wins / provider.gamesPlayed) * 100;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Profile', style: AppTheme.headline(context)),
      ),
      body: PremiumBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Avatar
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        gradient: AppTheme.accentGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.amethyst.withValues(alpha: 0.35),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 44,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Player Stats',
                      style: AppTheme.headline(context),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Your Numble journey at a glance',
                      style: AppTheme.body(context),
                    ),

                    const SizedBox(height: 28),

                    // Stats grid
                    Container(
                      decoration: AppTheme.glassCard(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _StatRow(
                            icon: Icons.sports_esports_rounded,
                            label: 'Games Played',
                            value: provider.gamesPlayed.toString(),
                            color: AppColors.amethyst,
                          ),
                          _divider(),
                          _StatRow(
                            icon: Icons.emoji_events_rounded,
                            label: 'Wins',
                            value: provider.wins.toString(),
                            color: AppColors.emerald,
                          ),
                          _divider(),
                          _StatRow(
                            icon: Icons.percent_rounded,
                            label: 'Win Rate',
                            value: '${winRate.toStringAsFixed(1)}%',
                            color: AppColors.gold,
                          ),
                          _divider(),
                          _StatRow(
                            icon: Icons.local_fire_department_rounded,
                            label: 'Current Streak',
                            value: provider.streak.toString(),
                            color: AppColors.coral,
                          ),
                          _divider(),
                          _StatRow(
                            icon: Icons.military_tech_rounded,
                            label: 'Max Streak',
                            value: provider.maxStreak.toString(),
                            color: AppColors.amethyst,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Highlight cards
                    Row(
                      children: [
                        Expanded(
                          child: _HighlightCard(
                            icon: Icons.trending_up_rounded,
                            label: 'Win Rate',
                            value: '${winRate.toStringAsFixed(0)}%',
                            gradient: AppTheme.primaryGradient,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _HighlightCard(
                            icon: Icons.whatshot_rounded,
                            label: 'Best Streak',
                            value: provider.maxStreak.toString(),
                            gradient: AppTheme.accentGradient,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Divider(
          color: AppColors.border.withValues(alpha: 0.4),
          height: 1,
        ),
      );
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label, style: AppTheme.body(context)),
          ),
          Text(value, style: AppTheme.statValue(context)),
        ],
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Gradient gradient;

  const _HighlightCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.amethyst.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 22),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTheme.statValue(context).copyWith(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTheme.label(context).copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
