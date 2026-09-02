// ignore_for_file: file_names

import 'package:flutter/material.dart';

/// Brand constants for the Antra Golden Hour (AGH) module.
class AGHColors {
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
  static const Color pageBg = Color(0xFFFAFAFC);
  static const Color cardBg = Colors.white;

  static const Color danger = Color(0xFFE53E3E);
  static const Color dangerSoft = Color(0xFFFEF0F0);
  static const Color success = Color(0xFF2E8B57);
  static const Color successSoft = Color(0xFFE9F7EF);
  static const Color warn = Color(0xFFC88B12);
  static const Color warnSoft = Color(0xFFFFF6E4);
  static const Color info = Color(0xFF5B66E1);
  static const Color infoSoft = Color(0xFFEEF1FF);
  static const Color scheduled = Color(0xFF2070B8);
  static const Color scheduledSoft = Color(0xFFE6F4FE);
}

enum AGHStatus { due, missed, upcoming, scheduled, completed, live, submitted }
