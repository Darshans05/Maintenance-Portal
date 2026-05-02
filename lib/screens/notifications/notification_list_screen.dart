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

          // Extract unique priorities from the list dynamically
          final uniquePriorities = provider.notifications
              .map((n) => n.priority)
              .where((p) => p.isNotEmpty)
              .toSet()
              .toList()
            ..sort();
          
          final dropdownItems = ['All', ...uniquePriorities];

          // Filter the notifications based on selected priority
          final filteredList = _selectedPriority == 'All'
              ? provider.notifications
              : provider.notifications
                  .where((n) => n.priority == _selectedPriority)
                  .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text('Filter by Priority: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownItems.contains(_selectedPriority) ? _selectedPriority : 'All',
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedPriority = newValue;
                            });
                          }
                        },
                        items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
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
