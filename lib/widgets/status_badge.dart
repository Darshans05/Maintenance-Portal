import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color _getStatusColor() {
    final s = status.toLowerCase();
    if (s.contains('open') || s.contains('new')) {
      return AppColors.statusOpen;
    } else if (s.contains('progress') || s.contains('process')) {
      return AppColors.statusInProgress;
    } else if (s.contains('closed') || s.contains('complete')) {
      return AppColors.statusClosed;
    } else if (s.contains('error') || s.contains('fail')) {
      return AppColors.statusError;
    }
    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getStatusColor().withOpacity(0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: _getStatusColor(),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
