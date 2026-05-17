// lib/screens/incident_list_screen.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kyra_works_test/common/common_widgets.dart';
import 'package:kyra_works_test/features/incidents/controller/incident_provider.dart';
import 'package:kyra_works_test/features/incidents/model/incident_model.dart';
import 'package:kyra_works_test/features/incidents/screens/incident_detail.dart';
import 'package:kyra_works_test/features/incidents/widgets/incident_list_widgets/incident_tile.dart';
import 'package:kyra_works_test/features/incidents/widgets/incident_list_widgets/stat_pill.dart';

class IncidentListScreen extends ConsumerStatefulWidget {
  const IncidentListScreen({super.key});

  @override
  ConsumerState<IncidentListScreen> createState() => _IncidentListScreenState();
}

class _IncidentListScreenState extends ConsumerState<IncidentListScreen> {
  static const int _itemsPerPage = 20;

  String? _lastSimulatedId;
  final ScrollController _scrollController = ScrollController();
  int _visibleItemCount = _itemsPerPage;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(incidentProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C12),
      appBar: _buildAppBar(state),
      body: _buildBody(state),
      bottomNavigationBar: _buildBottomBar(state),
    );
  }

  AppBar _buildAppBar(IncidentState state) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CAMPUS SAFETY', style: TextStyle(fontSize: 14)),
          if (state.loadState == LoadState.loaded)
            Text(
              '${state.incidents.length} incidents monitored',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.4),
                letterSpacing: 0.5,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          icon: Stack(
            children: [
              const Icon(Icons.filter_list, size: 20),
              if (state.filterStatus != null || state.filterSeverity != null)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF00D4FF),
                    ),
                  ),
                ),
            ],
          ),
          color: const Color(0xFF1A1D27),
          onSelected: (value) => _handleFilter(value),
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'clear',
              child: Text('Clear Filters', style: TextStyle(fontSize: 12)),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              enabled: false,
              child: Text(
                '— STATUS —',
                style: TextStyle(fontSize: 10, color: Colors.white38),
              ),
            ),
            ...IncidentStatus.values.map(
              (s) => PopupMenuItem(
                value: 'status_${s.value}',
                child: Text(s.label, style: const TextStyle(fontSize: 12)),
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              enabled: false,
              child: Text(
                '— SEVERITY —',
                style: TextStyle(fontSize: 10, color: Colors.white38),
              ),
            ),
            ...IncidentSeverity.values.map(
              (s) => PopupMenuItem(
                value: 'severity_${s.value}',
                child: Text(s.label, style: const TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),

        IconButton(
          icon: const Icon(Icons.refresh, size: 20),
          tooltip: 'Reload Simulation',
          onPressed: state.loadState == LoadState.loading
              ? null
              : () async {
                  setState(() {
                    _lastSimulatedId = null;
                    _resetVisibleItems();
                  });
                  await ref.read(incidentProvider.notifier).reload();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Simulation reset to initial mock data'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  void _handleFilter(String value) {
    final notifier = ref.read(incidentProvider.notifier);
    if (value == 'clear') {
      notifier.clearFilters();
      _resetVisibleItems();
      return;
    }

    if (value.startsWith('status_')) {
      final v = value.replaceFirst('status_', '');
      notifier.setStatusFilter(IncidentStatus.fromString(v));
      _resetVisibleItems();
      return;
    }

    if (value.startsWith('severity_')) {
      final v = value.replaceFirst('severity_', '');
      notifier.setSeverityFilter(IncidentSeverity.fromString(v));
      _resetVisibleItems();
    }
  }

  void _resetVisibleItems() {
    _visibleItemCount = _itemsPerPage;
    _isLoadingMore = false;
  }

  void _handleScroll() {
    if (!_scrollController.hasClients || _isLoadingMore) return;

    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 120) return;

    final state = ref.read(incidentProvider);
    if (state.loadState != LoadState.loaded) return;

    final filteredCount = _filteredIncidents(state).length;
    if (_visibleItemCount >= filteredCount) return;

    _loadMoreIncidents(filteredCount);
  }

  Future<void> _loadMoreIncidents(int totalItems) async {
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() {
      _visibleItemCount = math.min(
        _visibleItemCount + _itemsPerPage,
        totalItems,
      );
      _isLoadingMore = false;
    });
  }

  Widget _buildBody(IncidentState state) {
    switch (state.loadState) {
      case LoadState.loading:
        return _buildLoading();
      case LoadState.error:
        return ErrorStateWidget(
          message: state.errorMessage ?? 'Unknown error',
          onRetry: () => ref.read(incidentProvider.notifier).reload(),
        );
      case LoadState.loaded:
        if (state.isEmpty) return const EmptyStateWidget();
        return _buildList(state);
    }
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF00D4FF),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'LOADING INCIDENTS...',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.5,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(IncidentState state) {
    final filtered = _filteredIncidents(state);

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'NO INCIDENTS MATCH FILTERS',
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1.5,
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
      );
    }

    final visibleCount = math.min(_visibleItemCount, filtered.length);
    final visibleIncidents = filtered.take(visibleCount).toList();
    final hasMore = visibleCount < filtered.length;

    return Column(
      children: [
        _buildStatsBar(state),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: visibleIncidents.length + (_isLoadingMore ? 1 : 0),

            addRepaintBoundaries: true,
            addAutomaticKeepAlives: true,
            cacheExtent: visibleIncidents.length * 100,
            itemBuilder: (_, idx) {
              if (idx == visibleIncidents.length) {
                return _buildLoadMoreIndicator();
              }

              final incident = visibleIncidents[idx];
              return IncidentTile(
                key: ValueKey(incident.id),
                incident: incident,
                isNew: incident.id == _lastSimulatedId,
                onTap: () => _openDetail(incident.id),
              );
            },
          ),
        ),
        if (!hasMore && filtered.length > _itemsPerPage) _buildEndOfList(),
      ],
    );
  }

  List<IncidentModel> _filteredIncidents(IncidentState state) {
    final sorted = state.sortedIncidents;
    return sorted.where((i) {
      if (state.filterStatus != null && i.status != state.filterStatus) {
        return false;
      }
      if (state.filterSeverity != null && i.severity != state.filterSeverity) {
        return false;
      }
      return true;
    }).toList();
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 1.8,
              color: const Color(0xFF00D4FF).withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'LOADING MORE INCIDENTS...',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.2,
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndOfList() {
    return Container(
      color: const Color(0xFF0F1117),
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      child: Text(
        'ALL INCIDENTS LOADED',
        style: TextStyle(
          fontSize: 10,
          letterSpacing: 1.2,
          color: Colors.white.withValues(alpha: 0.28),
        ),
      ),
    );
  }

  Widget _buildStatsBar(IncidentState state) {
    final incidents = state.incidents;
    final criticalCount = incidents
        .where((i) => i.severity == IncidentSeverity.critical)
        .length;
    final newCount = incidents
        .where((i) => i.status == IncidentStatus.newIncident)
        .length;
    final escalatedCount = incidents
        .where((i) => i.status == IncidentStatus.escalated)
        .length;

    return Container(
      color: const Color(0xFF0F1117),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatPill(
              label: 'NEW',
              count: newCount,
              color: const Color(0xFF00D4FF),
            ),
            const SizedBox(width: 8),
            StatPill(
              label: 'CRITICAL',
              count: criticalCount,
              color: const Color(0xFFFF4040),
            ),
            const SizedBox(width: 8),
            StatPill(
              label: 'ESCALATED',
              count: escalatedCount,
              color: const Color(0xFFFF8C00),
            ),

            if (state.filterStatus != null || state.filterSeverity != null) ...[
              SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  ref.read(incidentProvider.notifier).clearFilters();
                  _resetVisibleItems();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D4FF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color(0xFF00D4FF).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.close, size: 10, color: Color(0xFF00D4FF)),
                      SizedBox(width: 3),
                      Text(
                        'CLEAR',
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 1,
                          color: Color(0xFF00D4FF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(IncidentState state) {
    final isLoading = state.loadState == LoadState.loading;

    return SafeArea(
      child: Container(
        color: const Color(0xFF0F1117),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: (isLoading || state.isSimulating)
                    ? null
                    : () async {
                        final notifier = ref.read(incidentProvider.notifier);
                        final incoming = await notifier
                            .simulateIncomingIncident();
                        // Determine the most-recent incident id from state

                        final newId = incoming.id;

                        if (mounted) {
                          setState(() => _lastSimulatedId = newId);

                          Future.delayed(const Duration(seconds: 5), () {
                            if (mounted) {
                              setState(() => _lastSimulatedId = null);
                            }
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '📡 Incoming incident received: $newId',
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                icon: state.isSimulating
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: Colors.white54,
                        ),
                      )
                    : const Icon(Icons.broadcast_on_personal, size: 16),
                label: Text(
                  state.isSimulating
                      ? 'RECEIVING...'
                      : 'SIMULATE INCOMING INCIDENT',
                  style: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF00D4FF,
                  ).withValues(alpha: 0.12),
                  foregroundColor: const Color(0xFF00D4FF),
                  side: const BorderSide(color: Color(0xFF00D4FF), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(String incidentId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => IncidentDetailScreen(incidentId: incidentId),
      ),
    );
  }
}
