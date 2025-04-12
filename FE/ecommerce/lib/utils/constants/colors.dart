import 'package:flutter/material.dart';

class CColors {
  CColors._();

  // App basic colors:
  static const Color primary = Colors.blue;
  static const Color secondary = Colors.black;
  static const Color accent = Colors.black;

  // Text colors:
  static const Color textPrimary = Colors.blue;
  static const Color textSecondary = Colors.black;
  static const Color textWhite = Colors.white;

  // Background colors:
  static const Color light = Colors.blue;
  static const Color dark = Colors.black;
  static const Color primaryBackground = Colors.black;

  // Gradient colors:
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xffff9a9e),
      Color(0xfffad0c4),
      Color(0xfffad0c4),
    ]
  );

  // Background container colors:

  // Button colors:

  // Border colors:
  static const Color grey = Colors.grey;

  // Error and Validation colors:

}