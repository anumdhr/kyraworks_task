import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionHeader({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 13, color: const Color(0xFF00D4FF)),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00D4FF),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(
              color: const Color(0xFF00D4FF).withValues(alpha: 0.2),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
