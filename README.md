#  Campus Safety Console

A Flutter safety incident review console for campus operators. The app loads mock incident data, supports status and severity filtering, and allows simulation of live incoming incidents with reactive list/detail sync.

---

##  Key Screens

- **Incident List**
  - Count and status pill summary
  - Status and severity filters
  - Infinite-list style paging with load-more behavior
  - Simulate an incoming incident
  - Reload mock incident data

- **Incident Detail**
  - Incident metadata and timeline
  - AI confidence bar
  - Recommended action card
  - Action buttons for under review, verify, dismiss, and escalate
  - Escalation lock forbids dismiss/verify on escalated cases

---

##  Actual Project Structure

`
lib/
├── main.dart
├── app.dart
├── common/
│   └── common_widgets.dart
├── core/
│   ├── functions.dart
│   └── theme/app_theme.dart
└── features/
    └── incidents/
        ├── controller/incident_provider.dart
        ├── data/mock_data.dart
        ├── model/incident_model.dart
        ├── screens/
        │   ├── incident_list.dart
        │   └── incident_detail.dart
        └── widgets/
            ├── incident_detail_widgets/
            │   ├── action_button.dart
            │   ├── confidencebar.dart
            │   └── section_header.dart
            └── incident_list_widgets/
                ├── incident_tile.dart
                ├── pulse_dot.dart
                └── stat_pill.dart
`

---

##  Architecture

- lib/main.dart sets up ProviderScope and locks portrait orientation.
- lib/app.dart configures MaterialApp with a dark theme and launches IncidentListScreen.
- lib/features/incidents/controller/incident_provider.dart contains the IncidentNotifier state manager and provider graph.
- lib/features/incidents/data/mock_data.dart supplies seeded incidents, the incoming SCH-1005 incident, and additional generated live incidents.
- lib/features/incidents/model/incident_model.dart defines incident fields, status/severity enums, and action permissions.
- lib/common/common_widgets.dart includes shared error/empty state UI and status/severity widgets.
- lib/core/theme/app_theme.dart holds themed appearance helpers used by severity/status widgets.

---

##  State Management

This app uses Flutter_riverpod with StateNotifier.

- incidentProvider provides the current IncidentState.
- incidentByIdProvider is a Provider.family that returns a single incident by ID.
- IncidentDetailScreen watches incidentByIdProvider(incidentId) so detail state updates automatically when the list updates.

---

##  Simulation & Sync Behavior

- **Simulate Incoming Incident**: the bottom button injects incomingIncident on first press and generates new incidents on subsequent presses.
- **Reload Simulation**: the app bar refresh button reloads initial mock data and resets the simulation state.
- **Duplicate handling**: _upsertIncident replaces an existing incident with the same id or prepends a new one.
- **Escalation lock**: escalated incidents cannot be dismissed or verified.

---

##  Dependencies

| Package | Version |
|---|---|
| Flutter_riverpod | ^3.3.1 |
| 
iverpod_annotation | ^4.0.2 |
| 	imeago | ^3.7.1 |
| intl | ^0.20.2 |
| cupertino_icons | ^1.0.8 |

---

##  Running the App

`Bash
flutter pub get
flutter run
`

**Recommended SDK:** Flutter 3.8.0+ / Dart 3.0.0+

---

##  Implemented Features

- Reactive incident list with filters
- Incident detail page with live update sync
- Mock incoming incident simulation
- Reload mock incident dataset
- Status guard logic for escalation
- Empty and error state handling

---

##  Notes

- App title is Campus Safety Console in lib/app.dart.
- IncidentDetailScreen reacts to updates from incidentByIdProvider.
- Seed data and incoming incident payload are defined in lib/features/incidents/data/mock_data.dart.
