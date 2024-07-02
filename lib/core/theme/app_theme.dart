import 'package:flutter/material.dart';

class ColorThemeElement {
  final String colorName;
  final Color color;

  ColorThemeElement({
    required this.colorName,
    required this.color,
  });
}

 final List<ColorThemeElement> colors = [
  ColorThemeElement(colorName: 'Blue', color: Colors.blue),
  ColorThemeElement(colorName: 'Red', color: Colors.red),
  ColorThemeElement(colorName: 'Green', color: Colors.lightGreen),
  ColorThemeElement(colorName: 'Pink', color: Colors.pink),
  ColorThemeElement(colorName: 'Purple', color: Colors.purple),
  ColorThemeElement(colorName: 'Teal', color: Colors.teal),
];

class AppTheme {
  final bool isDarkmode;
  final int colorThemeIndex;

  AppTheme({
    required this.isDarkmode,
    required this.colorThemeIndex,
  });

  ThemeData getTheme() => ThemeData(
      useMaterial3: true,
      colorSchemeSeed: colors[colorThemeIndex].color,
      brightness: isDarkmode ? Brightness.dark : Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity);
}
