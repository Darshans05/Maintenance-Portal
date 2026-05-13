import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/work_order_provider.dart';
import '../../providers/plant_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/text_styles.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final empId = authProvider.currentUser?.empId;
    if (empId != null) {
      Provider.of<NotificationProvider>(context, listen: false).fetchNotifications(empId);
      Provider.of<WorkOrderProvider>(context, listen: false).fetchWorkOrders(empId);
      Provider.of<PlantProvider>(context, listen: false).fetchPlants();
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
    });
    if (index == 1) {
      Navigator.pushNamed(context, '/work_orders');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/notifications');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    final notifProvider = Provider.of<NotificationProvider>(context);
    final woProvider = Provider.of<WorkOrderProvider>(context);
    final plantProvider = Provider.of<PlantProvider>(context);
    final plant = plantProvider.plant;

    final totalNotifications = notifProvider.notifications.length;
    final totalWorkOrders = woProvider.workOrders.length;
    final veryHighPriorityNotifications = notifProvider.notifications
        .where((n) => n.priority.contains('1'))
        .length;
    final veryHighPriorityWorkOrders = woProvider.workOrders
        .where((w) => w.priority.contains('1'))
        .length;
    final totalVeryHighPriority = veryHighPriorityNotifications + veryHighPriorityWorkOrders;
    final closedOrders = woProvider.workOrders
        .where((w) => w.status.toLowerCase().contains('close') || w.status.toLowerCase().contains('completed'))
        .length;
    final openOrders = totalWorkOrders - closedOrders;
    final totalActivity = totalNotifications + totalWorkOrders;
    final plantCode = plant?.code ?? '--';
    final plantName = plant?.name ?? '--';
    final plantLocation = plant?.location ?? '--';
    final dateText = _formatDate(DateTime.now());
    final progressValue = totalWorkOrders > 0 ? closedOrders / totalWorkOrders : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.engineering, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            const Text('Dashboard'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 8),
            Text(
              'Good afternoon, ${user?.name ?? 'Employee'}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7A7F8B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              plantName,
              style: AppTextStyles.heading1,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.apartment, size: 16, color: Color(0xFF9AA0B1)),
                const SizedBox(width: 6),
                Text(
                  'Plant $plantCode',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_today, size: 16, color: Color(0xFF9AA0B1)),
                const SizedBox(width: 6),
                Text(
                  dateText,
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Location: $plantLocation',
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.show_chart, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Plant Summary',
                          style: AppTextStyles.heading2.copyWith(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _MetricTile(
                          label: 'Total orders',
                          value: totalWorkOrders.toString(),
                          color: const Color(0xFF0A6ED1),
                        ),
                        _MetricTile(
                          label: 'Notifications',
                          value: totalNotifications.toString(),
                          color: const Color(0xFF388E3C),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _MetricTile(
                          label: 'Very high priority',
                          value: totalVeryHighPriority.toString(),
                          color: const Color(0xFFD32F2F),
                        ),
                        _MetricTile(
                          label: 'Total activity',
                          value: totalActivity.toString(),
                          color: const Color(0xFF0A6ED1),
                        ),
                      ],
                    ),
                    if (totalVeryHighPriority > 0) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Very high items: ${veryHighPriorityNotifications} notifications, ${veryHighPriorityWorkOrders} work orders',
                        style: AppTextStyles.bodySecondary.copyWith(fontSize: 13),
                      ),
                    ],
                    if (veryHighPriorityNotifications > 0) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF2C2C2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Color(0xFFD32F2F)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '$veryHighPriorityNotifications very-high priority notifications need attention.',
                                style: const TextStyle(
                                  color: Color(0xFFD32F2F),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _SectionHeader(
              title: 'Latest Alerts',
              onViewAll: () => Navigator.pushNamed(context, '/notifications'),
            ),
            const SizedBox(height: 12),
            if (notifProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (notifProvider.error.isNotEmpty)
              Text('Error: ${notifProvider.error}', style: const TextStyle(color: AppColors.statusError))
            else if (notifProvider.notifications.isEmpty)
              const Text('No notifications found.')
            else
              ...notifProvider.notifications.take(3).map(
                (n) => _AlertListItem(
                  notification: n,
                  onTap: () => Navigator.pushNamed(context, '/notification_detail', arguments: n),
                ),
              ),
            const SizedBox(height: 24),
            _SectionHeader(
              title: 'Latest Work Orders',
              onViewAll: () => Navigator.pushNamed(context, '/work_orders'),
            ),
            const SizedBox(height: 12),
            if (woProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (woProvider.error.isNotEmpty)
              Text('Error: ${woProvider.error}', style: const TextStyle(color: AppColors.statusError))
            else if (woProvider.workOrders.isEmpty)
              const Text('No work orders available.')
            else
              ...woProvider.workOrders.take(3).map(
                (w) => _WorkOrderListItem(workOrder: w),
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -4)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavButton(
              label: 'Dashboard',
              icon: Icons.dashboard,
              selected: _selectedTab == 0,
              onTap: () => _onTabSelected(0),
              badgeCount: 0,
            ),
            _NavButton(
              label: 'Work Orders',
              icon: Icons.build,
              selected: _selectedTab == 1,
              onTap: () => _onTabSelected(1),
              badgeCount: totalWorkOrders,
            ),
            _NavButton(
              label: 'Alerts',
              icon: Icons.notifications,
              selected: _selectedTab == 2,
              onTap: () => _onTabSelected(2),
              badgeCount: totalNotifications,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySecondary,
          ),
        ],
      ),
    );
  }
}

class _AlertListItem extends StatelessWidget {
  final dynamic notification;
  final VoidCallback onTap;

  const _AlertListItem({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE8E8),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.notification_important, color: Color(0xFFD32F2F), size: 22),
        ),
        title: Text(
          notification.qmTxt,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Priority: ${notification.priority} • ${notification.date}',
          style: AppTextStyles.bodySecondary,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF9AA0B1)),
        onTap: onTap,
      ),
    );
  }
}

class _WorkOrderListItem extends StatelessWidget {
  final dynamic workOrder;

  const _WorkOrderListItem({required this.workOrder});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F4FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.build_circle_outlined, color: Color(0xFF0A6ED1), size: 22),
        ),
        title: Text(
          workOrder.ktext,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Order: ${workOrder.aufnr} • Status: ${workOrder.status}',
          style: AppTextStyles.bodySecondary,
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 24, color: selected ? AppColors.primary : const Color(0xFF9AA0B1)),
              if (badgeCount > 0)
                Positioned(
                  right: -8,
                  top: -8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD32F2F),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badgeCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: selected ? AppColors.primary : const Color(0xFF9AA0B1),
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const _SectionHeader({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.heading2),
        TextButton(
          onPressed: onViewAll,
          child: const Text('View All'),
        ),
      ],
    );
  }
}
