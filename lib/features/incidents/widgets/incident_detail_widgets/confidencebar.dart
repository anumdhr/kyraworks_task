import 'package:flutter/material.dart';

class ConfidenceBar extends StatelessWidget {
  final int confidence;

  const ConfidenceBar({super.key, required this.confidence});

  Color get _barColor {
    if (confidence >= 90) return const Color(0xFFFF4040);
    if (confidence >= 75) return const Color(0xFFFF8C00);
    if (confidence >= 60) return const Color(0xFFFFD700);
    return const Color(0xFF4CAF50);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'AI CONFIDENCE',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 1,
                color: Colors.white.withValues(alpha: 0.4),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '$confidence%',
              style: TextStyle(
                fontSize: 11,
                color: _barColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: confidence / 100,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(_barColor),
            minHeight: 3,
          ),
        ),
      ],
    );
  }
}
