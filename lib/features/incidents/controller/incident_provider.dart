// lib/providers/incident_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:kyra_works_test/features/incidents/data/mock_data.dart';
import 'package:kyra_works_test/features/incidents/model/incident_model.dart';

enum LoadState { loading, loaded, error }

class IncidentState {
  final List<IncidentModel> incidents;
  final LoadState loadState;
  final String? errorMessage;
  final bool isSimulating;

  const IncidentState({
    this.incidents = const [],
    this.loadState = LoadState.loading,
    this.errorMessage,
    this.isSimulating = false,
  });

  IncidentState copyWith({
    List<IncidentModel>? incidents,
    LoadState? loadState,
    String? errorMessage,
    bool? isSimulating,
  }) {
    return IncidentState(
      incidents: incidents ?? this.incidents,
      loadState: loadState ?? this.loadState,
      errorMessage: errorMessage,
      isSimulating: isSimulating ?? this.isSimulating,
    );
  }

  List<IncidentModel> get sortedIncidents {
    final sorted = List<IncidentModel>.from(incidents);
    sorted.sort((a, b) => b.time.compareTo(a.time));
    return sorted;
  }

  bool get isEmpty => incidents.isEmpty && loadState == LoadState.loaded;
}

class IncidentNotifier extends StateNotifier<IncidentState> {
  IncidentNotifier() : super(const IncidentState()) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(loadState: LoadState.loading);
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

  Future<void> simulateIncomingIncident() async {
    state = state.copyWith(isSimulating: true);
    await Future.delayed(const Duration(milliseconds: 400));

    final incoming = incomingIncident;
    _upsertIncident(incoming);

    state = state.copyWith(isSimulating: false);
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

final incidentProvider = StateNotifierProvider<IncidentNotifier, IncidentState>(
  (ref) {
    return IncidentNotifier();
  },
);

final incidentByIdProvider = Provider.family<IncidentModel?, String>((ref, id) {
  final incidents = ref.watch(incidentProvider).incidents;
  try {
    return incidents.firstWhere((i) => i.id == id);
  } catch (_) {
    return null;
  }
});
