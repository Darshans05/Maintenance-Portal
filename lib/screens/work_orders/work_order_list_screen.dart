import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/work_order_provider.dart';
import '../../widgets/work_order_card.dart';

class WorkOrderListScreen extends StatefulWidget {
  const WorkOrderListScreen({super.key});

  @override
  State<WorkOrderListScreen> createState() => _WorkOrderListScreenState();
}

class _WorkOrderListScreenState extends State<WorkOrderListScreen> {
  String _selectedPriority = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Orders'),
      ),
      body: Consumer<WorkOrderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error.isNotEmpty) {
            return Center(child: Text('Error: \${provider.error}'));
          }
          if (provider.workOrders.isEmpty) {
            return const Center(child: Text('No work orders found.'));
          }

          // Extract unique priorities from the list dynamically
          final uniquePriorities = provider.workOrders
              .map((w) => w.priority)
              .where((p) => p.isNotEmpty)
              .toSet()
              .toList()
            ..sort();
          
          final dropdownItems = ['All', ...uniquePriorities];

          // Filter the work orders based on selected priority
          final filteredList = _selectedPriority == 'All'
              ? provider.workOrders
              : provider.workOrders
                  .where((w) => w.priority == _selectedPriority)
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
                            Center(child: Text('No work orders match this filter.')),
                          ],
                        )
                      : ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            return WorkOrderCard(
                              item: item,
                              onTap: () {
                                Navigator.pushNamed(context, '/work_order_detail', arguments: item);
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
