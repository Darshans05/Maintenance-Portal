import 'package:flutter/material.dart';
import '../models/work_order_item.dart';
import '../core/constants/text_styles.dart';
import 'status_badge.dart';

class WorkOrderCard extends StatelessWidget {
  final WorkOrderItem item;
  final VoidCallback onTap;

  const WorkOrderCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.aufnr,
                    style: AppTextStyles.bodyText.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  StatusBadge(status: item.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.ktext,
                style: AppTextStyles.heading2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Plant: ${item.werks}',
                    style: AppTextStyles.bodySecondary,
                  ),
                  if (item.equipment.isNotEmpty)
                    Text(
                      'Equip: ${item.equipment}',
                      style: AppTextStyles.bodySecondary,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
