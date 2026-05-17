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
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return Colors.white24;
            return color;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.white.withValues(alpha: 0.04);
            }
            return color.withValues(alpha: 0.15);
          }),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return const BorderSide(color: Colors.white10);
            }
            return BorderSide(color: color.withValues(alpha: 0.5));
          }),
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ),
    );
  }
}
