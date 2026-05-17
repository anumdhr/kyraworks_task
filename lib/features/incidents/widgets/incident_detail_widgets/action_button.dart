import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final String? disabledReason;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.onPressed,
    this.isDisabled = false,
    this.disabledReason,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isDisabled ? (disabledReason ?? 'Unavailable') : label,
      child: ElevatedButton.icon(
        onPressed: isDisabled ? null : onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: const TextStyle(fontSize: 12, letterSpacing: 0.5),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: isDisabled ? Colors.white38 : color,
          backgroundColor: isDisabled
              ? Colors.white.withValues(alpha: 0.05)
              : color.withValues(alpha: 0.15),
          side: BorderSide(
            color: isDisabled ? Colors.white12 : color.withValues(alpha: 0.5),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}
