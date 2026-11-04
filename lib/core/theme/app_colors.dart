import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Light mode ──
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSecondaryBackground = Color(0xFFF5F5F7);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE8E8ED);
  static const Color lightPrimaryText = Color(0xFF1D1D1F);
  static const Color lightSecondaryText = Color(0xFF6E6E73);
  static const Color lightTertiaryText = Color(0xFF86868B);
  static const Color lightDivider = Color(0x33D2D2D7);
  static const Color lightAccent = Color(0xFF0071E3);
  static const Color lightAccentPressed = Color(0xFF0066CC);

  // ── Dark mode ──
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSecondaryBackground = Color(0xFF1C1C1E);
  static const Color darkSurface = Color(0xFF2C2C2E);
  static const Color darkBorder = Color(0xFF38383A);
  static const Color darkPrimaryText = Color(0xFFF5F5F7);
  static const Color darkSecondaryText = Color(0xFFA1A1A6);
  static const Color darkTertiaryText = Color(0xFF86868B);
  static const Color darkDivider = Color(0x33545458);
  static const Color darkAccent = Color(0xFF2997FF);
  static const Color darkAccentPressed = Color(0xFF0A84FF);

  // ── Status colors (shared) ──
  static const Color statusSubmitted = Color(0xFFFF9F0A);
  static const Color statusInProgress = Color(0xFF0A84FF);
  static const Color statusResolved = Color(0xFF30D158);
  static const Color statusRejected = Color(0xFF8E8E93);

  // ── Priority ──
  static const Color priorityUrgent = Color(0xFFFF3B30);
  static const Color priorityHigh = Color(0xFFFF9F0A);
  static const Color priorityNormal = Color(0xFF0A84FF);
  static const Color priorityLow = Color(0xFF8E8E93);

  // ── Semantic ──
  static const Color destructive = Color(0xFFFF3B30);
  static const Color success = Color(0xFF30D158);
  static const Color warning = Color(0xFFFF9F0A);
  static const Color info = Color(0xFF0A84FF);
}