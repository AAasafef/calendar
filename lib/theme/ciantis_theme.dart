import 'package:flutter/material.dart';

/// Shared palette + type colors used across every CIANTIS screen so the
/// look stays consistent (matches the "paper" mock: warm cream surfaces,
/// deep taupe ink, soft muted accent dots for event categories).
class CiantisColors {
  CiantisColors._();

  static const bg = Color(0xFFF6F2EC);
  static const card = Color(0xFFF8F4EE);
  static const ink = Color(0xFF4A4039);
  static const muted = Color(0xFF9A918B);
  static const active = Color(0xFF76675C);
  static const tabFill = Color(0xFFE9E1D8);
  static const rule = Color(0x1A4A4039);

  /// Warm terracotta used sparingly for the raised quick-add button.
  static const accent = Color(0xFFC97B4A);

  static const Map<String, Color> typeColors = {
    'Work': Color(0xFF90A999),
    'Meeting': Color(0xFFAAA4C1),
    'Health': Color(0xFFC59A8B),
    'Family': Color(0xFFD1A7B0),
    'Task': Color(0xFFC9A862),
    'School': Color(0xFF8CAEA7),
    'Reminder': Color(0xFFBFA8C7),
    'Appointment': Color(0xFF94AFC6),
  };
}
