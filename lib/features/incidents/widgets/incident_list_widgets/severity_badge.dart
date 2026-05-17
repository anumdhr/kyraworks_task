import 'package:flutter/material.dart';
import 'package:kyra_works_test/core/theme/app_theme.dart';
import 'package:kyra_works_test/features/incidents/model/incident_model.dart';

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
        border: Border.all(color: style.color.withValues(alpha: 0.5), width: 1),
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
