// lib/app.dart

import 'package:flutter/material.dart';
import 'package:kyra_works_test/features/incidents/screens/incident_list.dart';

class SchoolSafetyApp extends StatelessWidget {
  const SchoolSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Safety Console',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const IncidentListScreen(),
    );
  }
}
