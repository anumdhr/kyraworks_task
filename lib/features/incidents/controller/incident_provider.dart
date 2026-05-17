// lib/providers/incident_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kyra_works_test/features/incidents/data/mock_data.dart';
import 'package:kyra_works_test/features/incidents/model/incident_model.dart';

enum LoadState { loading, loaded, error }

class IncidentState {
  static const Object _unset = Object();

  final List<IncidentModel> incidents;
  final LoadState loadState;
  final String? errorMessage;
  final bool isSimulating;
  final int simulationCount;
  final IncidentStatus? filterStatus;
  final IncidentSeverity? filterSeverity;

  const IncidentState({
    this.incidents = const [],
    this.loadState = LoadState.loading,
    this.errorMessage,
    this.isSimulating = false,
    this.simulationCount = 0,
    this.filterStatus,
    this.filterSeverity,
  });

  IncidentState copyWith({
    List<IncidentModel>? incidents,
    LoadState? loadState,
    String? errorMessage,
    bool? isSimulating,
    int? simulationCount,
    Object? filterStatus = _unset,
    Object? filterSeverity = _unset,
  }) {
    return IncidentState(
      incidents: incidents ?? this.incidents,
      loadState: loadState ?? this.loadState,
      errorMessage: errorMessage,
      isSimulating: isSimulating ?? this.isSimulating,
      simulationCount: simulationCount ?? this.simulationCount,
      filterStatus: filterStatus == _unset
          ? this.filterStatus
          : filterStatus as IncidentStatus?,
      filterSeverity: filterSeverity == _unset
          ? this.filterSeverity
          : filterSeverity as IncidentSeverity?,
    );
  }

  List<IncidentModel> get sortedIncidents {
    final sorted = List<IncidentModel>.from(incidents);
    sorted.sort((a, b) => b.time.compareTo(a.time));
    return sorted;
  }

  bool get isEmpty => incidents.isEmpty && loadState == LoadState.loaded;
}

class IncidentNotifier extends Notifier<IncidentState> {
  @override
  IncidentState build() {
    state = const IncidentState();
    _load();
    return state;
  }

  Future<void> _load() async {
    state = state.copyWith(loadState: LoadState.loading, simulationCount: 0);
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      final incidents = generateSeedIncidents();
      state = state.copyWith(incidents: incidents, loadState: LoadState.loaded);
    } catch (e) {
      state = state.copyWith(
        loadState: LoadState.error,
        errorMessage: 'Failed to load incidents: $e',
      );
    }
  }

  Future<void> reload() async {
    await _load();
  }

  void setStatusFilter(IncidentStatus? status) {
    state = state.copyWith(filterStatus: status, filterSeverity: null);
  }

  void setSeverityFilter(IncidentSeverity? severity) {
    state = state.copyWith(filterSeverity: severity, filterStatus: null);
  }

  void clearFilters() {
    state = state.copyWith(filterStatus: null, filterSeverity: null);
  }

  Future<void> simulateIncomingIncident() async {
    state = state.copyWith(isSimulating: true);
    await Future.delayed(const Duration(milliseconds: 400));

    final count = state.simulationCount;
    final IncidentModel incoming;

    if (count == 0) {
      incoming = incomingIncident;
    } else {
      incoming = generateLiveIncident(count);
    }
    _upsertIncident(incoming);

    state = state.copyWith(isSimulating: false, simulationCount: count + 1);
  }

  String? updateStatus(String incidentId, IncidentStatus newStatus) {
    final idx = state.incidents.indexWhere((i) => i.id == incidentId);
    if (idx == -1) return 'Incident not found.';

    final incident = state.incidents[idx];

    if (incident.status == IncidentStatus.escalated) {
      if (newStatus == IncidentStatus.dismissed ||
          newStatus == IncidentStatus.verified) {
        return 'Escalated incidents cannot be ${newStatus.label.toLowerCase()}.';
      }
    }

    final updated = incident.copyWith(status: newStatus);
    _upsertIncident(updated);
    return null;
  }

  void _upsertIncident(IncidentModel incident) {
    final list = List<IncidentModel>.from(state.incidents);
    final existingIdx = list.indexWhere((i) => i.id == incident.id);

    if (existingIdx >= 0) {
      list[existingIdx] = incident;
    } else {
      list.insert(0, incident);
    }

    state = state.copyWith(incidents: list);
  }
}

final incidentProvider = NotifierProvider<IncidentNotifier, IncidentState>(
  IncidentNotifier.new,
);

final incidentByIdProvider = Provider.family<IncidentModel?, String>((ref, id) {
  final incidents = ref.watch(incidentProvider).incidents;
  try {
    return incidents.firstWhere((i) => i.id == id);
  } catch (_) {
    return null;
  }
});
