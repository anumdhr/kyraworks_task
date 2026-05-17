// lib/data/mock_data.dart

import 'dart:math';

import 'package:kyra_works_test/features/incidents/model/incident_model.dart';

final Map<String, dynamic> incomingIncidentJson = {
  "id": "SCH-1005",
  "severity": "high",
  "category": "Playground Boundary Alert",
  "location": "Playground - East Fence",
  "cameraName": "Playground East Camera",
  "status": "new",
  "time": "2026-05-11T10:22:00",
  "confidence": 89,
  "description":
      "A student-like figure was detected close to the playground boundary fence.",
  "recommendedAction": "Review immediately and notify duty staff if confirmed.",
  "timeline": [
    "Movement detected near playground fence",
    "Person remained near boundary for more than 30 seconds",
    "No teacher detected nearby",
  ],
};

IncidentModel get incomingIncident =>
    IncidentModel.fromJson(incomingIncidentJson);

List<IncidentModel> generateSeedIncidents() {
  final incidents = <IncidentModel>[];

  incidents.add(
    IncidentModel.fromJson({
      "id": "SCH-1001",
      "severity": "critical",
      "category": "Restricted Area Access",
      "location": "Main Building - Rooftop Door",
      "cameraName": "Rooftop Entrance Camera",
      "status": "new",
      "time": "2026-05-11T10:15:00",
      "confidence": 94,
      "description":
          "A student-like figure was detected near the restricted rooftop access door during class hours.",
      "recommendedAction":
          "Verify immediately and escalate to school administration if confirmed.",
      "timeline": [
        "Movement detected near restricted rooftop door",
        "Person remained near access point for more than 20 seconds",
        "No authorized staff detected nearby",
      ],
    }),
  );

  final categories = [
    'Restricted Area Access',
    'Playground Boundary Alert',
    'Unauthorized Visitor',
    'Suspicious Behavior',
    'Physical Altercation',
    'Vandalism',
    'After-Hours Activity',
    'Gate Breach',
    'Loitering',
    'Emergency Exit Breach',
    'Parking Lot Incident',
    'Cafeteria Disturbance',
    'Hallway Confrontation',
    'Equipment Tampering',
    'Fire Exit Blocked',
  ];

  final locations = [
    'Main Building - Entrance',
    'Gymnasium - Side Exit',
    'Library - Rear',
    'Cafeteria - Emergency Exit',
    'Parking Lot A',
    'Parking Lot B',
    'Science Wing - Lab 3',
    'Administration - Roof',
    'Playground - West Fence',
    'Playground - North Gate',
    'Sports Field - Perimeter',
    'Bus Bay - Zone 2',
    'Teacher Lounge - Corridor',
    'Storage Room - Basement',
    'Server Room - IT Wing',
    'Chemistry Lab - Room 204',
    'Art Room - Building C',
    'Boiler Room - Sub-level',
    'Main Gate - Security Post',
    'East Wing - Stairwell',
  ];

  final cameras = [
    'Entrance Cam 1',
    'Entrance Cam 2',
    'Gym Perimeter Cam',
    'Library Ext Cam',
    'Cafeteria Cam A',
    'Parking Lot Cam 1',
    'Parking Lot Cam 2',
    'Science Wing Cam',
    'Roof Cam NE',
    'Playground North Cam',
    'Sports Field Cam',
    'Bus Bay Cam 2',
    'Admin Corridor Cam',
    'Basement Cam',
    'Server Room Cam',
    'Chem Lab Cam',
    'Art Block Cam',
    'Boiler Room Cam',
    'Main Gate Cam',
    'East Stairwell Cam',
  ];

  final severities = ['low', 'medium', 'high', 'critical'];

  final timelineTemplates = [
    [
      'Motion detected in restricted zone',
      'Individual remained stationary for 45 seconds',
      'No authorized personnel in vicinity',
    ],
    [
      'Unusual activity flagged by AI model',
      'Camera tracked movement across restricted boundary',
      'Alert escalated to review queue',
    ],
    [
      'Door sensor triggered simultaneously',
      'Camera captured individual approaching',
      'Identity verification not possible from angle',
    ],
    [
      'Perimeter sensor activated',
      'Camera feed shows movement near fence',
      'No response from nearby staff',
    ],
    [
      'Object left unattended detected',
      'Area cordoned off by duty officer',
      'Follow-up review required',
    ],
  ];

  final descriptionTemplates = [
    'A person was detected in a restricted area during school hours. Immediate review recommended.',
    'Camera captured unusual movement near a secured entry point. Confidence level indicates likely unauthorized access.',
    'An individual was observed lingering near a boundary for an extended period without staff present.',
    'Motion sensors and camera feeds confirm presence of an unidentified person in a restricted zone.',
    'AI detection flagged suspicious behavior in proximity to a secured asset or boundary.',
    'After-hours movement detected by perimeter cameras. No authorized personnel logged.',
    'Visitor detected in a restricted corridor without valid badge or escort.',
    'Equipment access door opened without corresponding badge swipe detected.',
    'Crowding behavior detected near a fire exit, potentially blocking emergency egress.',
    'Vehicle parked in restricted zone for more than 30 minutes without authorization.',
  ];

  final actionTemplates = [
    'Review footage and notify security personnel immediately.',
    'Cross-reference with badge access logs and verify identity.',
    'Send duty officer to location and assess situation.',
    'Escalate to administration if activity is confirmed suspicious.',
    'Review with campus security and document findings.',
    'Alert nearby staff and request visual confirmation.',
    'Check visitor log and match against camera timestamp.',
    'Dispatch security patrol to the reported area.',
    'Verify with parking authority and issue warning if unauthorized.',
    'Confirm with IT team if server room access was authorized.',
  ];

  final baseTime = DateTime(2026, 5, 11, 10, 15);
  // final rng = _SeededRandom(42);
  final random = Random();

  for (int i = 2; i <= 510; i++) {
    final id = 'SCH-${1000 + i}';
    final severityStr = severities[random.nextInt(4)];
    final catIdx = random.nextInt(categories.length);
    final locIdx = random.nextInt(locations.length);
    final camIdx = random.nextInt(cameras.length);
    final timelineIdx = random.nextInt(timelineTemplates.length);
    final descIdx = random.nextInt(descriptionTemplates.length);
    final actionIdx = random.nextInt(actionTemplates.length);
    final confidence = 60 + random.nextInt(39);
    final minutesAgo = random.nextInt(60 * 24 * 7);

    incidents.add(
      IncidentModel(
        id: id,
        severity: IncidentSeverity.fromString(severityStr),
        category: categories[catIdx],
        location: locations[locIdx],
        cameraName: cameras[camIdx],
        status: IncidentStatus.newIncident,
        time: baseTime.subtract(Duration(minutes: minutesAgo)),
        confidence: confidence,
        description: descriptionTemplates[descIdx],
        recommendedAction: actionTemplates[actionIdx],
        timeline: timelineTemplates[timelineIdx],
      ),
    );
  }

  incidents.sort((a, b) => b.time.compareTo(a.time));

  return incidents;
}
