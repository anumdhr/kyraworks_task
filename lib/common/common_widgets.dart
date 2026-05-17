// lib/widgets/shared_widgets.dart

import 'package:flutter/material.dart';
import 'package:kyra_works_test/core/theme/app_theme.dart';
import 'package:kyra_works_test/features/incidents/model/incident_model.dart';

// ---------------------------------------------------------------------------
// Severity Badge
// ---------------------------------------------------------------------------

class SeverityBadge extends StatelessWidget {
  final IncidentSeverity severity;
  final bool compact;

  const SeverityBadge({
    super.key,
    required this.severity,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = severityStyle(severity);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: style.color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: compact ? 10 : 12, color: style.color),
          const SizedBox(width: 4),
          Text(
            style.label,
            style: TextStyle(
              fontSize: compact ? 9 : 10,
              fontWeight: FontWeight.bold,
              color: style.color,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status Chip
// ---------------------------------------------------------------------------

class StatusChip extends StatelessWidget {
  final IncidentStatus status;
  final bool compact;

  const StatusChip({super.key, required this.status, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final style = statusStyle(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: style.color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: compact ? 10 : 12, color: style.color),
          const SizedBox(width: 4),
          Text(
            status.label.toUpperCase(),
            style: TextStyle(
              fontSize: compact ? 9 : 10,
              fontWeight: FontWeight.bold,
              color: style.color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Confidence Bar
// ---------------------------------------------------------------------------

class ConfidenceBar extends StatelessWidget {
  final int confidence;

  const ConfidenceBar({super.key, required this.confidence});

  Color get _barColor {
    if (confidence >= 90) return const Color(0xFFFF4040);
    if (confidence >= 75) return const Color(0xFFFF8C00);
    if (confidence >= 60) return const Color(0xFFFFD700);
    return const Color(0xFF4CAF50);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'AI CONFIDENCE',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 1,
                color: Colors.white.withOpacity(0.4),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '$confidence%',
              style: TextStyle(
                fontSize: 11,
                color: _barColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: confidence / 100,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(_barColor),
            minHeight: 3,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Section Header (for detail screen sections)
// ---------------------------------------------------------------------------

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionHeader({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 13, color: const Color(0xFF00D4FF)),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00D4FF),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(
              color: const Color(0xFF00D4FF).withOpacity(0.2),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action Button
// ---------------------------------------------------------------------------

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final String? disabledReason;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.onPressed,
    this.isDisabled = false,
    this.disabledReason,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isDisabled ? (disabledReason ?? 'Unavailable') : label,
      child: ElevatedButton.icon(
        onPressed: isDisabled ? null : onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: const TextStyle(fontSize: 12, letterSpacing: 0.5),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: isDisabled ? Colors.white38 : color,
          backgroundColor: isDisabled
              ? Colors.white.withOpacity(0.05)
              : color.withOpacity(0.15),
          side: BorderSide(
            color: isDisabled ? Colors.white12 : color.withOpacity(0.5),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error State Widget
// ---------------------------------------------------------------------------

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFFFF4040)),
            const SizedBox(height: 16),
            Text(
              'SYSTEM ERROR',
              style: const TextStyle(
                fontSize: 12,
                letterSpacing: 2,
                color: Color(0xFFFF4040),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('RETRY'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF00D4FF),
                side: const BorderSide(color: Color(0xFF00D4FF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty State Widget
// ---------------------------------------------------------------------------

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 64,
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          Text(
            'NO INCIDENTS',
            style: TextStyle(
              fontSize: 13,
              letterSpacing: 2,
              color: Colors.white.withOpacity(0.3),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All clear. Campus is secure.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
