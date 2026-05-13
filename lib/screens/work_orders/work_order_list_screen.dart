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

          final filteredList = provider.workOrders;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Showing ${filteredList.length} work orders',
                  style: const TextStyle(color: Color(0xFF666666), fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
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
