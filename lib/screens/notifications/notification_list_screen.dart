import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/notification_card.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  String _selectedPriority = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error.isNotEmpty) {
            return Center(child: Text('Error: \${provider.error}'));
          }
          if (provider.notifications.isEmpty) {
            return const Center(child: Text('No notifications found.'));
          }

          // Parse and categorize priorities
          final _getPriorityCategory = (String priority) {
            if (priority.contains('1')) return 'High';
            if (priority.contains('2')) return 'High';
            if (priority.contains('3')) return 'Low';
            return 'Low';
          };
          
          final filterOptions = ['All', 'High', 'Low'];
          final counts = {
            'All': provider.notifications.length,
            'High': provider.notifications.where((n) => _getPriorityCategory(n.priority).contains('High')).length,
            'Low': provider.notifications.where((n) => _getPriorityCategory(n.priority).contains('Low')).length,
          };
          final filteredList = _selectedPriority == 'All'
              ? provider.notifications
              : provider.notifications
                  .where((n) => _getPriorityCategory(n.priority) == _selectedPriority)
                  .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filter by Priority:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: filterOptions.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final value = filterOptions[index];
                          final count = counts[value] ?? 0;
                          final isSelected = _selectedPriority == value;
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.white,
                              side: BorderSide(
                                color: isSelected ? Theme.of(context).primaryColor : const Color(0xFFDADADA),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedPriority = value;
                              });
                            },
                            child: Text(
                              '$value ($count)',
                              style: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFF333333),
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Showing ${filteredList.length} of ${provider.notifications.length} notifications',
                      style: const TextStyle(color: Color(0xFF666666)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // Refresh logic can be hooked up here if needed
                  },
                  child: filteredList.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 100),
                            Center(child: Text('No notifications match this filter.')),
                          ],
                        )
                      : ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            return NotificationCard(
                              item: item,
                              onTap: () {
                                Navigator.pushNamed(context, '/notification_detail', arguments: item);
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
