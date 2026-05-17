// lib/models/incident.dart

enum IncidentStatus {
  newIncident('new', 'New'),
  underReview('under_review', 'Under Review'),
  verified('verified', 'Verified'),
  dismissed('dismissed', 'Dismissed'),
  escalated('escalated', 'Escalated');

  const IncidentStatus(this.value, this.label);
  final String value;
  final String label;

  static IncidentStatus fromString(String value) {
    return IncidentStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => IncidentStatus.newIncident,
    );
  }
}

enum IncidentSeverity {
  low('low', 'Low'),
  medium('medium', 'Medium'),
  high('high', 'High'),
  critical('critical', 'Critical');

  const IncidentSeverity(this.value, this.label);
  final String value;
  final String label;

  static IncidentSeverity fromString(String value) {
    return IncidentSeverity.values.firstWhere(
      (s) => s.value == value,
      orElse: () => IncidentSeverity.low,
    );
  }

  int get priority {
    switch (this) {
      case IncidentSeverity.critical:
        return 4;
      case IncidentSeverity.high:
        return 3;
      case IncidentSeverity.medium:
        return 2;
      case IncidentSeverity.low:
        return 1;
    }
  }
}

class Incident {
  final String id;
  final IncidentSeverity severity;
  final String category;
  final String location;
  final String cameraName;
  final IncidentStatus status;
  final DateTime time;
  final int confidence;
  final String description;
  final String recommendedAction;
  final List<String> timeline;

  const Incident({
    required this.id,
    required this.severity,
    required this.category,
    required this.location,
    required this.cameraName,
    required this.status,
    required this.time,
    required this.confidence,
    required this.description,
    required this.recommendedAction,
    required this.timeline,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'] as String,
      severity: IncidentSeverity.fromString(json['severity'] as String),
      category: json['category'] as String,
      location: json['location'] as String,
      cameraName: json['cameraName'] as String,
      status: IncidentStatus.fromString(json['status'] as String),
      time: DateTime.parse(json['time'] as String),
      confidence: json['confidence'] as int,
      description: json['description'] as String,
      recommendedAction: json['recommendedAction'] as String,
      timeline: List<String>.from(json['timeline'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'severity': severity.value,
      'category': category,
      'location': location,
      'cameraName': cameraName,
      'status': status.value,
      'time': time.toIso8601String(),
      'confidence': confidence,
      'description': description,
      'recommendedAction': recommendedAction,
      'timeline': timeline,
    };
  }

  Incident copyWith({
    String? id,
    IncidentSeverity? severity,
    String? category,
    String? location,
    String? cameraName,
    IncidentStatus? status,
    DateTime? time,
    int? confidence,
    String? description,
    String? recommendedAction,
    List<String>? timeline,
  }) {
    return Incident(
      id: id ?? this.id,
      severity: severity ?? this.severity,
      category: category ?? this.category,
      location: location ?? this.location,
      cameraName: cameraName ?? this.cameraName,
      status: status ?? this.status,
      time: time ?? this.time,
      confidence: confidence ?? this.confidence,
      description: description ?? this.description,
      recommendedAction: recommendedAction ?? this.recommendedAction,
      timeline: timeline ?? this.timeline,
    );
  }

  /// Escalated incidents cannot be dismissed or verified
  bool get canDismiss => status != IncidentStatus.escalated;
  bool get canVerify => status != IncidentStatus.escalated;
  bool get canMarkUnderReview =>
      status == IncidentStatus.newIncident ||
      status == IncidentStatus.escalated;
  bool get canEscalate => status != IncidentStatus.escalated;
  bool get needsAttention =>
      status == IncidentStatus.newIncident ||
      status == IncidentStatus.underReview;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Incident && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Incident(id: $id, status: ${status.label})';
}
