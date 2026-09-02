// ignore_for_file: file_names

import 'package:flutter/material.dart';

/// Brand constants for the Raise Escalation module — shares the AGH pink→purple
/// gradient family so the two flows visually belong together.
class EscColors {
  static const Color pink = Color(0xFFE94C9B);
  static const Color purple = Color(0xFF8B47C6);

  static const LinearGradient gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pink, purple],
  );

  static const LinearGradient gradientSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFF0F7), Color(0xFFF4EDFA)],
  );

  static const Color text = Color(0xFF222222);
  static const Color textSoft = Color(0xFF6B6B72);
  static const Color textFaint = Color(0xFFA0A0A8);
  static const Color line = Color(0xFFE4E4E9);
  static const Color pageBg = Color(0xFFF6F4F8);
  static const Color fieldLocked = Color(0xFFFAFAFC);

  static const Color danger = Color(0xFFE53E3E);
  static const Color dangerSoft = Color(0xFFFEF0F0);
  static const Color dangerBorder = Color(0xFFFECACA);
}
