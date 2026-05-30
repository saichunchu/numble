import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';

/// Shared motion tokens for consistent, fluid UI.
abstract final class AppMotion {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration medium = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 480);
  static const Duration flip = Duration(milliseconds: 420);
  static const Duration staggerStep = Duration(milliseconds: 70);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve flipCurve = Curves.easeInOutCubic;
  static const Curve pop = Curves.easeOutBack;

  static Widget fadeSlideTransition(Widget child, Animation<double> animation) {
    final curved = CurvedAnimation(parent: animation, curve: enter);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }

  static Widget scaleFadeTransition(Widget child, Animation<double> animation) {
    final curved = CurvedAnimation(parent: animation, curve: enter);
    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
        child: child,
      ),
    );
  }

  static void runStaggered(VoidCallback action, int index) {
    if (index <= 0) {
      action();
      return;
    }
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      Future.delayed(staggerStep * index, action);
    });
  }
}
