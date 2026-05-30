import 'package:flutter/material.dart';
import 'constants.dart';

class GameLayoutData {
  final double tileSize;
  final double tileFontSize;
  final double tileMargin;
  final double keyHeight;
  final double keyFontSize;
  final double maxContentWidth;
  final double gridHeight;
  final double subtitleFontSize;
  final double resultFontSize;
  final double titleFontSize;
  final bool useScroll;

  const GameLayoutData({
    required this.tileSize,
    required this.tileFontSize,
    required this.tileMargin,
    required this.keyHeight,
    required this.keyFontSize,
    required this.maxContentWidth,
    required this.gridHeight,
    required this.subtitleFontSize,
    required this.resultFontSize,
    required this.titleFontSize,
    required this.useScroll,
  });

  factory GameLayoutData.fromConstraints(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final height = constraints.maxHeight.isFinite ? constraints.maxHeight : 700;

    final isWide = width > 600;
    final maxContentWidth = isWide ? 480.0 : width;

    final tileMargin = isWide ? 4.0 : 3.0;
    const keyRows = 4;
    const keyPadding = 8.0;

    final keyHeight = (maxContentWidth / 3 * 0.38).clamp(42.0, 58.0);
    final keyboardHeight = keyRows * (keyHeight + keyPadding) + 16;
    const headerHeight = 72.0;
    const resultHeight = 36.0;
    const verticalSpacing = 56.0;

    final gridAreaHeight =
        height - keyboardHeight - headerHeight - resultHeight - verticalSpacing;

    final tileFromWidth =
        (maxContentWidth - tileMargin * 2 * wordLength) / wordLength;
    final tileFromHeight =
        (gridAreaHeight - tileMargin * 2 * maxAttempts) / maxAttempts;

    final tileSize =
        (tileFromWidth < tileFromHeight ? tileFromWidth : tileFromHeight)
            .clamp(32.0, 64.0);

    final gridHeight = maxAttempts * (tileSize + tileMargin * 2);

    final totalContentHeight =
        headerHeight + gridHeight + resultHeight + keyboardHeight + verticalSpacing;

    return GameLayoutData(
      tileSize: tileSize,
      tileFontSize: (tileSize * 0.42).clamp(16.0, 28.0),
      tileMargin: tileMargin,
      keyHeight: keyHeight,
      keyFontSize: (keyHeight * 0.38).clamp(14.0, 22.0),
      maxContentWidth: maxContentWidth,
      gridHeight: gridHeight,
      subtitleFontSize: isWide ? 15.0 : 14.0,
      resultFontSize: isWide ? 20.0 : 18.0,
      titleFontSize: isWide ? 24.0 : 22.0,
      useScroll: totalContentHeight > height,
    );
  }
}

class GameLayout extends InheritedWidget {
  final GameLayoutData data;

  const GameLayout({
    super.key,
    required this.data,
    required super.child,
  });

  static GameLayoutData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<GameLayout>();
    assert(scope != null, 'GameLayout not found in widget tree');
    return scope!.data;
  }

  @override
  bool updateShouldNotify(GameLayout oldWidget) => data != oldWidget.data;
}
