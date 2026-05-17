// lib/widgets/incident_tile.dart

import 'package:flutter/material.dart';
import 'package:kyra_works_test/common/common_widgets.dart';
import 'package:kyra_works_test/core/functions.dart';
import 'package:kyra_works_test/core/theme/app_theme.dart';
import 'package:kyra_works_test/features/incidents/model/incident_model.dart';
import 'package:kyra_works_test/features/incidents/widgets/incident_list_widgets/pulse_dot.dart';

class IncidentTile extends StatelessWidget {
  final IncidentModel incident;
  final VoidCallback onTap;
  final bool isNew;

  const IncidentTile({
    super.key,
    required this.incident,
    required this.onTap,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    final sevStyle = severityStyle(incident.severity);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: isNew
                  ? const Color(0xFF00D4FF).withValues(alpha: 0.08)
                  : const Color(0xFF1A1D27),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isNew
                    ? const Color(0xFF00D4FF).withValues(alpha: 0.5)
                    : sevStyle.color.withValues(alpha: 0.15),
                width: isNew ? 1.5 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SeverityBadge(severity: incident.severity, compact: true),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          incident.category,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isNew)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D4FF),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      Text(
                        formatTime(incident.time),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.4),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 11,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          incident.location,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.videocam_outlined,
                        size: 11,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        incident.cameraName,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      StatusChip(status: incident.status, compact: true),
                      const SizedBox(width: 8),
                      Text(
                        incident.id,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.25),
                          fontFamily: 'Courier',
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      if (incident.needsAttention)
                        PulsingDot(color: sevStyle.color),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
