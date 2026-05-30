import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class PremiumBackground extends StatelessWidget {
  final Widget child;

  const PremiumBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                AppColors.backgroundMid,
                Color(0xFF0A0814),
              ],
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -60,
          child: _GlowOrb(
            color: AppColors.amethyst.withValues(alpha: 0.18),
            size: 260,
          ),
        ),
        Positioned(
          bottom: 120,
          left: -100,
          child: _GlowOrb(
            color: AppColors.emerald.withValues(alpha: 0.12),
            size: 320,
          ),
        ),
        Positioned(
          top: MediaQuery.sizeOf(context).height * 0.35,
          left: MediaQuery.sizeOf(context).width * 0.5 - 80,
          child: _GlowOrb(
            color: AppColors.gold.withValues(alpha: 0.06),
            size: 180,
          ),
        ),
        child,
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}
