import 'package:flutter/material.dart';
import '../../models/notification_item.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/app_colors.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as NotificationItem;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notification #${item.qmNum}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card with priority badge
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Priority Badge and Number
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE4E4),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.trending_up, color: Color(0xFFD32F2F), size: 16),
                              const SizedBox(width: 6),
                              Text(
                                _getPriorityText(item.priority),
                                style: const TextStyle(
                                  color: Color(0xFFD32F2F),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '#${item.qmNum}',
                          style: const TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Title
                    Text(
                      item.qmTxt,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Priority Level with progress bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Priority level',
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              _getPriorityText(item.priority),
                              style: const TextStyle(
                                color: Color(0xFFD32F2F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _getPriorityValue(item.priority),
                            minHeight: 6,
                            backgroundColor: const Color(0xFFE0E0E0),
                            valueColor: AlwaysStoppedAnimation(
                              _getPriorityColor(item.priority),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Alert box for high priority
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4E4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFCCCC), width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.warning_amber_rounded, color: Color(0xFFD32F2F)),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'This notification is marked ${_getPriorityText(item.priority)} priority.',
                          style: const TextStyle(
                            color: Color(0xFFD32F2F),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Immediate attention required.',
                          style: TextStyle(
                            color: Color(0xFFD32F2F),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Timeline Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timeline, color: Color(0xFF0066CC), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Timeline',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0066CC),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _TimelineItem(
                      icon: Icons.error_outline,
                      label: 'Malfunction Start',
                      value: item.formattedDate.isNotEmpty ? item.formattedDate : 'N/A',
                      iconColor: const Color(0xFF666666),
                    ),
                    const SizedBox(height: 16),
                    _TimelineItem(
                      icon: Icons.calendar_today,
                      label: 'Notification Date',
                      value: item.formattedDate.isNotEmpty ? item.formattedDate : 'N/A',
                      iconColor: const Color(0xFF666666),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Details Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xFF00AA00), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Details',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00AA00),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _DetailItem(
                      icon: Icons.tag,
                      label: 'Notification No.',
                      value: item.qmNum,
                      iconColor: const Color(0xFF666666),
                    ),
                    const SizedBox(height: 12),
                    _DetailItem(
                      icon: Icons.factory,
                      label: 'Plant',
                      value: item.plant.isNotEmpty ? item.plant : 'N/A',
                      iconColor: const Color(0xFF666666),
                    ),
                    const SizedBox(height: 12),
                    _DetailItem(
                      icon: Icons.build,
                      label: 'Equipment',
                      value: item.equipment.isNotEmpty ? item.equipment : 'N/A',
                      iconColor: const Color(0xFF666666),
                    ),
                    const SizedBox(height: 12),
                    _DetailItem(
                      icon: Icons.label_outline,
                      label: 'Notification Type',
                      value: item.notificationType.isNotEmpty ? item.notificationType : 'N/A',
                      iconColor: const Color(0xFF666666),
                    ),
                    const SizedBox(height: 12),
                    _DetailItem(
                      icon: Icons.category,
                      label: 'Category',
                      value: item.category.isNotEmpty ? item.category : 'N/A',
                      iconColor: const Color(0xFF666666),
                    ),
                    const SizedBox(height: 12),
                    _DetailItem(
                      icon: Icons.flag,
                      label: 'Priority',
                      value: _getPriorityText(item.priority),
                      valueColor: const Color(0xFFD32F2F),
                      iconColor: const Color(0xFF666666),
                    ),
                    const SizedBox(height: 12),
                    _DetailItem(
                      icon: Icons.person,
                      label: 'Created By',
                      value: item.createdBy.isNotEmpty ? item.createdBy : 'N/A',
                      iconColor: const Color(0xFF666666),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPriorityText(String priority) {
    if (priority.contains('1')) return '1-Very high';
    if (priority.contains('2')) return '2-High';
    if (priority.contains('3')) return '3-Medium';
    return '4-Low';
  }

  double _getPriorityValue(String priority) {
    if (priority.contains('1')) return 1.0;
    if (priority.contains('2')) return 0.75;
    if (priority.contains('3')) return 0.5;
    return 0.25;
  }

  Color _getPriorityColor(String priority) {
    if (priority.contains('1')) return const Color(0xFFD32F2F);
    if (priority.contains('2')) return const Color(0xFFF57C00);
    if (priority.contains('3')) return const Color(0xFFFBC02D);
    return const Color(0xFF388E3C);
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _TimelineItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color? valueColor;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
