import 'package:flutter/material.dart';
import '../../models/notification_item.dart';
import '../../widgets/status_badge.dart';
import '../../core/constants/text_styles.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as NotificationItem;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.qmNum),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Notification details', style: AppTextStyles.heading2),
                    StatusBadge(status: item.status),
                  ],
                ),
                const Divider(height: 32),
                _DetailRow(label: 'Description', value: item.qmTxt),
                _DetailRow(label: 'Number', value: item.qmNum),
                _DetailRow(label: 'Priority', value: item.priority),
                _DetailRow(label: 'Date', value: item.date),
                _DetailRow(label: 'Created By', value: item.createdBy),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.bodySecondary),
          const SizedBox(height: 4),
          Text(value.isNotEmpty ? value : '-', style: AppTextStyles.bodyText),
        ],
      ),
    );
  }
}
