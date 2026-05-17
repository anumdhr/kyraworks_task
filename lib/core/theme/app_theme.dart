// lib/utils/theme.dart

import 'package:flutter/material.dart';
import 'package:kyra_works_test/features/incidents/model/incident_model.dart';

class AppTheme {
  AppTheme._();

  static const _fontFamily = 'Courier';

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00D4FF),
      secondary: Color(0xFFFF6B35),
      surface: Color(0xFF0F1117),
      surfaceContainerHigh: Color(0xFF1A1D27),
      onSurface: Color(0xFFE8ECF0),
      error: Color(0xFFFF4040),
    ),
    scaffoldBackgroundColor: const Color(0xFF0A0C12),
    cardColor: const Color(0xFF1A1D27),
    fontFamily: _fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0F1117),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: Color(0xFF00D4FF),
      ),
      iconTheme: IconThemeData(color: Color(0xFF00D4FF)),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2A2D3A),
      thickness: 1,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: Color(0xFF1A1D27),
      selectedColor: Color(0xFF00D4FF),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    ),
  );
}

class SeverityStyle {
  final Color color;
  final Color background;
  final IconData icon;
  final String label;

  const SeverityStyle({
    required this.color,
    required this.background,
    required this.icon,
    required this.label,
  });
}

SeverityStyle severityStyle(IncidentSeverity severity) {
  switch (severity) {
    case IncidentSeverity.critical:
      return const SeverityStyle(
        color: Color(0xFFFF4040),
        background: Color(0x33FF4040),
        icon: Icons.crisis_alert,
        label: 'CRITICAL',
      );
    case IncidentSeverity.high:
      return const SeverityStyle(
        color: Color(0xFFFF8C00),
        background: Color(0x33FF8C00),
        icon: Icons.warning_amber_rounded,
        label: 'HIGH',
      );
    case IncidentSeverity.medium:
      return const SeverityStyle(
        color: Color(0xFFFFD700),
        background: Color(0x33FFD700),
        icon: Icons.info_outline_rounded,
        label: 'MEDIUM',
      );
    case IncidentSeverity.low:
      return const SeverityStyle(
        color: Color(0xFF4CAF50),
        background: Color(0x334CAF50),
        icon: Icons.check_circle_outline,
        label: 'LOW',
      );
  }
}

class StatusStyle {
  final Color color;
  final Color background;
  final IconData icon;

  const StatusStyle({
    required this.color,
    required this.background,
    required this.icon,
  });
}

StatusStyle statusStyle(IncidentStatus status) {
  switch (status) {
    case IncidentStatus.newIncident:
      return const StatusStyle(
        color: Color(0xFF00D4FF),
        background: Color(0x2200D4FF),
        icon: Icons.fiber_new_rounded,
      );
    case IncidentStatus.underReview:
      return const StatusStyle(
        color: Color(0xFFFFD700),
        background: Color(0x22FFD700),
        icon: Icons.remove_red_eye_outlined,
      );
    case IncidentStatus.verified:
      return const StatusStyle(
        color: Color(0xFF4CAF50),
        background: Color(0x224CAF50),
        icon: Icons.verified_outlined,
      );
    case IncidentStatus.dismissed:
      return const StatusStyle(
        color: Color(0xFF9E9E9E),
        background: Color(0x229E9E9E),
        icon: Icons.cancel_outlined,
      );
    case IncidentStatus.escalated:
      return const StatusStyle(
        color: Color(0xFFFF4040),
        background: Color(0x22FF4040),
        icon: Icons.trending_up_rounded,
      );
  }
}
