import 'package:flutter/material.dart';

class CColors {
  CColors._();

  // App basic colors:
  static const Color primary = Colors.blue;
  static const Color secondary = Color.fromARGB(255, 240, 255, 75);
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
      ]);

  // Background container colors:
  static const Color lightContainer = Color(0xFFF6F6F6);
  // static const Color darkContainer = CColors.white.withValues(alpha: 0.1)

  // Button colors:

  // Border colors:
  static const Color grey = Colors.grey;
  static const Color lightGrey = Color(0xFFF6F6F6);

  // Error and Validation colors:
}
