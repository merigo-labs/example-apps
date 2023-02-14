import 'package:flutter/material.dart';

class ColorPalette {
  
  const ColorPalette._();
  
  static const Brightness brightness = Brightness.dark;
  static const Color text = Color(0xFFFFFFFF);
  static const Color subtext = Color(0xFFC8C8C9);
  static const Color background = Color(0xFF19191A);
  static const Color surface = Color(0xFF2D3034);
  static const Color disabled = Color(0xFF2D3034);
  static const List<Color> solana = [
    Color(0xFF9945FF),
    Color(0xFF14F195),
  ];

  static ColorScheme scheme() => const ColorScheme.dark(
    primary: text,
    secondary: subtext,
    background: background,
    surface: surface,
  );
}