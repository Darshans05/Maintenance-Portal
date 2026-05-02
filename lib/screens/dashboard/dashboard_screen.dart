import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/work_order_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/text_styles.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    final notifProvider = Provider.of<NotificationProvider>(context);
    final woProvider = Provider.of<WorkOrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              "Welcome, ${user?.name ?? 'Employee'}",
              style: AppTextStyles.heading1,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Notifications',
                    count: notifProvider.isLoading ? '...' : notifProvider.notifications.length.toString(),
                    icon: Icons.notifications,
                    color: AppColors.statusOpen,
                    onTap: () => Navigator.pushNamed(context, '/notifications'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryCard(
                    title: 'Work Orders',
                    count: woProvider.isLoading ? '...' : woProvider.workOrders.length.toString(),
                    icon: Icons.build,
                    color: AppColors.statusInProgress,
                    onTap: () => Navigator.pushNamed(context, '/work_orders'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _SectionHeader(
              title: 'Recent Notifications',
              onViewAll: () => Navigator.pushNamed(context, '/notifications'),
            ),
            if (notifProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (notifProvider.error.isNotEmpty)
              Text('Error: ${notifProvider.error}', style: TextStyle(color: AppColors.statusError))
            else if (notifProvider.notifications.isEmpty)
              const Text('No notifications found.')
            else
              ...notifProvider.notifications.take(3).map((n) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.notifications, color: Colors.white, size: 20),
                    ),
                    title: Text(n.qmNum, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(n.qmTxt, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Text(n.status),
                    onTap: () => Navigator.pushNamed(context, '/notification_detail', arguments: n),
                  )),
            const SizedBox(height: 24),
            _SectionHeader(
              title: 'Recent Work Orders',
              onViewAll: () => Navigator.pushNamed(context, '/work_orders'),
            ),
            if (woProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (woProvider.error.isNotEmpty)
              Text('Error: ${woProvider.error}', style: TextStyle(color: AppColors.statusError))
            else if (woProvider.workOrders.isEmpty)
              const Text('No work orders found.')
            else
              ...woProvider.workOrders.take(3).map((w) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.build, color: Colors.white, size: 20),
                    ),
                    title: Text(w.aufnr, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(w.ktext, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Text(w.status),
                    onTap: () => Navigator.pushNamed(context, '/work_order_detail', arguments: w),
                  )),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 16),
            Text(count, style: AppTextStyles.heading1.copyWith(fontSize: 32)),
            const SizedBox(height: 4),
            Text(title, style: AppTextStyles.bodySecondary),
          ],
        ),
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
