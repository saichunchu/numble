import 'package:flutter/material.dart';

class GameLayoutData {
  final double tileSize;
  final double tileFontSize;
  final double tileMargin;
  final double keyHeight;
  final double keyFontSize;
  final double keyPadding;
  final double keyboardHeight;
  final double maxContentWidth;
  final double gridHeight;
  final double gridPanelHeight;
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
    required this.keyPadding,
    required this.keyboardHeight,
    required this.maxContentWidth,
    required this.gridHeight,
    required this.gridPanelHeight,
    required this.subtitleFontSize,
    required this.resultFontSize,
    required this.titleFontSize,
    required this.useScroll,
  });

  factory GameLayoutData.fromConstraints(
    BoxConstraints constraints, {
    required int wordLength,
    required int maxAttempts,
  }) {
    final width = constraints.maxWidth;
    final height = constraints.maxHeight.isFinite ? constraints.maxHeight : 700;

    final isWide = width > 600;
    final isCompact = height < 560;
    final maxContentWidth = isWide ? 480.0 : width;

    final tileMargin = isWide ? 4.0 : 3.0;
    const keyRows = 4;
    final keyPadding = isCompact ? 3.0 : (isWide ? 5.0 : 4.0);

    // Premium UI chrome heights
    const subtitleHeight = 40.0;
    const gridPanelPadding = 24.0;
    const resultHeight = 44.0;
    final verticalSpacing = isCompact ? 32.0 : 48.0;

    final tileFromWidth =
        (maxContentWidth - tileMargin * 2 * wordLength) / wordLength;

    final estimatedKeyHeight = (tileFromWidth * 0.68)
        .clamp(isCompact ? 28.0 : 32.0, isWide ? 46.0 : 50.0);
    final estimatedKeyboardHeight =
        keyRows * (estimatedKeyHeight + keyPadding * 2) + 28;

    final gridAreaHeight = height -
        estimatedKeyboardHeight -
        subtitleHeight -
        gridPanelPadding -
        resultHeight -
        verticalSpacing;

    final tileFromHeight =
        (gridAreaHeight - tileMargin * 2 * maxAttempts) / maxAttempts;

    final tileSize = (tileFromWidth < tileFromHeight ? tileFromWidth : tileFromHeight)
        .clamp(isCompact ? 26.0 : 30.0, 64.0);

    final keyHeight = (tileSize * 0.68)
        .clamp(isCompact ? 28.0 : 32.0, isWide ? 46.0 : 50.0);
    final keyboardHeight = keyRows * (keyHeight + keyPadding * 2) + 28;
    final gridHeight = maxAttempts * (tileSize + tileMargin * 2);
    final gridPanelHeight = gridHeight + gridPanelPadding;

    final totalContentHeight = subtitleHeight +
        gridPanelHeight +
        resultHeight +
        keyboardHeight +
        verticalSpacing;

    return GameLayoutData(
      tileSize: tileSize,
      tileFontSize: (tileSize * 0.42).clamp(14.0, 28.0),
      tileMargin: tileMargin,
      keyHeight: keyHeight,
      keyFontSize: (keyHeight * 0.42).clamp(12.0, 20.0),
      keyPadding: keyPadding,
      keyboardHeight: keyboardHeight,
      maxContentWidth: maxContentWidth,
      gridHeight: gridHeight,
      gridPanelHeight: gridPanelHeight,
      subtitleFontSize: isWide ? 15.0 : 13.0,
      resultFontSize: isWide ? 20.0 : 17.0,
      titleFontSize: isWide ? 24.0 : 22.0,
      useScroll: totalContentHeight > height * 0.95,
    );
  }

  /// Shrinks tiles so the grid fits inside [panel] without overflowing.
  GameLayoutData fittedForPanel(
    BoxConstraints panel, {
    required int wordLength,
    required int maxAttempts,
  }) {
    if (panel.maxHeight.isInfinite || panel.maxWidth.isInfinite) {
      return this;
    }

    final tileFromHeight =
        (panel.maxHeight - tileMargin * 2 * maxAttempts) / maxAttempts;
    final tileFromWidth =
        (panel.maxWidth - tileMargin * 2 * wordLength) / wordLength;

    var fittedTile = tileSize;
    if (tileFromHeight < fittedTile) fittedTile = tileFromHeight;
    if (tileFromWidth < fittedTile) fittedTile = tileFromWidth;
    fittedTile = fittedTile.clamp(22.0, tileSize);

    if ((fittedTile - tileSize).abs() < 0.5) return this;

    final fittedGridHeight = maxAttempts * (fittedTile + tileMargin * 2);
    return GameLayoutData(
      tileSize: fittedTile,
      tileFontSize: (fittedTile * 0.42).clamp(12.0, 28.0),
      tileMargin: tileMargin,
      keyHeight: keyHeight,
      keyFontSize: keyFontSize,
      keyPadding: keyPadding,
      keyboardHeight: keyboardHeight,
      maxContentWidth: maxContentWidth,
      gridHeight: fittedGridHeight,
      gridPanelHeight: fittedGridHeight + 24,
      subtitleFontSize: subtitleFontSize,
      resultFontSize: resultFontSize,
      titleFontSize: titleFontSize,
      useScroll: useScroll,
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

  static GameLayoutData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GameLayout>()
        ?.data;
  }

  @override
  bool updateShouldNotify(GameLayout oldWidget) => data != oldWidget.data;
}
