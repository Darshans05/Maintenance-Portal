import 'package:flutter/material.dart';
import '../models/notification_item.dart';
import '../core/constants/text_styles.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onTap;

  const NotificationCard({super.key, required this.item, required this.onTap});

  String _getPriorityText(String priority) {
    if (priority.contains('1')) return '1-Very high';
    if (priority.contains('2')) return '2-High';
    if (priority.contains('3')) return '3-Medium';
    return '4-Low';
  }

  Color _getPriorityColor(String priority) {
    if (priority.contains('1')) return const Color(0xFFD32F2F);
    if (priority.contains('2')) return const Color(0xFFF57C00);
    if (priority.contains('3')) return const Color(0xFFFBC02D);
    return const Color(0xFF388E3C);
  }

  Color _getPriorityBgColor(String priority) {
    if (priority.contains('1')) return const Color(0xFFFFE4E4);
    if (priority.contains('2')) return const Color(0xFFFFE0B2);
    if (priority.contains('3')) return const Color(0xFFFFF9C4);
    return const Color(0xFFE8F5E9);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with priority badge and notification number
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getPriorityBgColor(item.priority),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getPriorityText(item.priority),
                      style: TextStyle(
                        color: _getPriorityColor(item.priority),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    '#${item.qmNum}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                item.qmTxt,
                style: AppTextStyles.heading2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Priority progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Priority',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _getPriorityText(item.priority),
                        style: TextStyle(
                          color: _getPriorityColor(item.priority),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: item.priority.contains('1')
                          ? 1.0
                          : item.priority.contains('2')
                              ? 0.75
                              : item.priority.contains('3')
                                  ? 0.5
                                  : 0.25,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFE0E0E0),
                      valueColor: AlwaysStoppedAnimation(
                        _getPriorityColor(item.priority),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Footer with date and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.date,
                    style: const TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.status,
                      style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
