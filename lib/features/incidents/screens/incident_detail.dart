// lib/screens/incident_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kyra_works_test/common/common_widgets.dart';
import 'package:kyra_works_test/core/theme/app_theme.dart';
import 'package:kyra_works_test/features/incidents/controller/incident_provider.dart';
import 'package:kyra_works_test/features/incidents/model/incident_model.dart';
import 'package:kyra_works_test/features/incidents/widgets/incident_detail_widgets/action_button.dart';
import 'package:kyra_works_test/features/incidents/widgets/incident_detail_widgets/confidencebar.dart';
import 'package:kyra_works_test/features/incidents/widgets/incident_detail_widgets/section_header.dart';

class IncidentDetailScreen extends ConsumerWidget {
  final String incidentId;

  const IncidentDetailScreen({super.key, required this.incidentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the specific incident reactively — if it updates (live or from
    // status change), this widget rebuilds automatically. This is the
    // "Active Detail Sync" requirement from the spec.
    final incident = ref.watch(incidentByIdProvider(incidentId));

    if (incident == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0C12),
        appBar: AppBar(title: const Text('INCIDENT DETAIL')),
        body: Center(
          child: Text(
            'Incident not found.',
            style: TextStyle(color: Colors.white.withOpacity(0.4)),
          ),
        ),
      );
    }

    final sevStyle = severityStyle(incident.severity);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C12),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              incident.id,
              style: const TextStyle(fontSize: 14, letterSpacing: 1.5),
            ),
            Text(
              incident.category,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.4),
                letterSpacing: 0.3,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: StatusChip(status: incident.status),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card: severity, location, camera, time
            _buildHeaderCard(incident, sevStyle),
            const SizedBox(height: 16),

            // AI Confidence
            ConfidenceBar(confidence: incident.confidence),
            const SizedBox(height: 20),

            // Description
            const SectionHeader(
              title: 'DESCRIPTION',
              icon: Icons.description_outlined,
            ),
            Text(
              incident.description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.75),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),

            // Recommended Action
            const SectionHeader(
              title: 'RECOMMENDED ACTION',
              icon: Icons.lightbulb_outline,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00D4FF).withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF00D4FF).withOpacity(0.2),
                ),
              ),
              child: Text(
                incident.recommendedAction,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF00D4FF),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Timeline
            const SectionHeader(
              title: 'TIMELINE',
              icon: Icons.timeline_outlined,
            ),
            ...incident.timeline.asMap().entries.map((entry) {
              return _TimelineEntry(
                index: entry.key,
                text: entry.value,
                isLast: entry.key == incident.timeline.length - 1,
              );
            }),
            const SizedBox(height: 24),

            // Actions
            const SectionHeader(
              title: 'ACTIONS',
              icon: Icons.touch_app_outlined,
            ),
            _buildActionGrid(context, ref, incident),

            // Escalation warning
            if (incident.status == IncidentStatus.escalated)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4040).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFFFF4040).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: Color(0xFFFF4040),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This incident is escalated. Dismiss and Verify actions are locked.',
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xFFFF4040).withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(IncidentModel incident, SeverityStyle sevStyle) {
    final fmt = DateFormat('MMM d, yyyy  HH:mm');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: sevStyle.color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: sevStyle.color.withOpacity(0.25), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SeverityBadge(severity: incident.severity),
              const Spacer(),
              Icon(
                Icons.access_time,
                size: 12,
                color: sevStyle.color.withOpacity(0.7),
              ),
              const SizedBox(width: 4),
              Text(
                fmt.format(incident.time),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'LOCATION',
            value: incident.location,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.videocam_outlined,
            label: 'CAMERA',
            value: incident.cameraName,
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(
    BuildContext context,
    WidgetRef ref,
    IncidentModel incident,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Mark as Under Review
        ActionButton(
          label: 'Under Review',
          icon: Icons.remove_red_eye_outlined,
          color: const Color(0xFFFFD700),
          isDisabled:
              !incident.canMarkUnderReview ||
              incident.status == IncidentStatus.underReview,
          disabledReason: incident.status == IncidentStatus.underReview
              ? 'Already under review'
              : null,
          onPressed: () =>
              _updateStatus(context, ref, incident, IncidentStatus.underReview),
        ),

        // Verify
        ActionButton(
          label: 'Verify',
          icon: Icons.verified_outlined,
          color: const Color(0xFF4CAF50),
          isDisabled:
              !incident.canVerify || incident.status == IncidentStatus.verified,
          disabledReason: !incident.canVerify
              ? 'Escalated incidents cannot be verified'
              : incident.status == IncidentStatus.verified
              ? 'Already verified'
              : null,
          onPressed: () =>
              _updateStatus(context, ref, incident, IncidentStatus.verified),
        ),

        // Dismiss
        ActionButton(
          label: 'Dismiss',
          icon: Icons.cancel_outlined,
          color: const Color(0xFF9E9E9E),
          isDisabled:
              !incident.canDismiss ||
              incident.status == IncidentStatus.dismissed,
          disabledReason: !incident.canDismiss
              ? 'Escalated incidents cannot be dismissed'
              : incident.status == IncidentStatus.dismissed
              ? 'Already dismissed'
              : null,
          onPressed: () =>
              _updateStatus(context, ref, incident, IncidentStatus.dismissed),
        ),

        // Escalate
        ActionButton(
          label: 'Escalate',
          icon: Icons.trending_up_rounded,
          color: const Color(0xFFFF4040),
          isDisabled:
              !incident.canEscalate ||
              incident.status == IncidentStatus.escalated,
          disabledReason: 'Already escalated',
          onPressed: () => _showEscalateConfirmation(context, ref, incident),
        ),
      ],
    );
  }

  void _updateStatus(
    BuildContext context,
    WidgetRef ref,
    IncidentModel incident,
    IncidentStatus newStatus,
  ) {
    final error = ref
        .read(incidentProvider.notifier)
        .updateStatus(incident.id, newStatus);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ $error'),
          backgroundColor: const Color(0xFFFF4040).withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✓ Incident ${incident.id} marked as ${newStatus.label}',
          ),
          backgroundColor: const Color(0xFF4CAF50).withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showEscalateConfirmation(
    BuildContext context,
    WidgetRef ref,
    IncidentModel incident,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D27),
        title: const Text(
          'ESCALATE INCIDENT',
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 1.5,
            color: Color(0xFFFF4040),
          ),
        ),
        content: Text(
          'This will escalate incident ${incident.id} to administration. '
          'Dismiss and Verify actions will be locked.\n\nContinue?',
          style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.white38),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _updateStatus(context, ref, incident, IncidentStatus.escalated);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4040).withOpacity(0.2),
              foregroundColor: const Color(0xFFFF4040),
            ),
            child: const Text('ESCALATE'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info row
// ---------------------------------------------------------------------------

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13, color: Colors.white38),
        const SizedBox(width: 6),
        Text(
          '$label  ',
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white38,
            letterSpacing: 0.8,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Timeline entry
// ---------------------------------------------------------------------------

class _TimelineEntry extends StatelessWidget {
  final int index;
  final String text;
  final bool isLast;

  const _TimelineEntry({
    required this.index,
    required this.text,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00D4FF).withOpacity(0.7),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: const Color(0xFF00D4FF).withOpacity(0.2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
