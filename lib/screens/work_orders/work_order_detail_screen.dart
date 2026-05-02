import 'package:flutter/material.dart';
import '../../models/work_order_item.dart';
import '../../widgets/status_badge.dart';
import '../../core/constants/text_styles.dart';

class WorkOrderDetailScreen extends StatelessWidget {
  const WorkOrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as WorkOrderItem;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.aufnr),
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
                    Text('Work Order details', style: AppTextStyles.heading2),
                    StatusBadge(status: item.status),
                  ],
                ),
                const Divider(height: 32),
                _DetailRow(label: 'Description', value: item.ktext),
                _DetailRow(label: 'Order Number', value: item.aufnr),
                _DetailRow(label: 'Plant', value: item.werks),
                _DetailRow(label: 'Equipment', value: item.equipment),
                _DetailRow(label: 'Functional Location', value: item.functionalLocation),
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
