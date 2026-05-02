import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/work_order_item.dart';

class WorkOrderProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<WorkOrderItem> _workOrders = [];
  bool _isLoading = false;
  String _error = '';

  List<WorkOrderItem> get workOrders => _workOrders;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchWorkOrders(String empId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _workOrders = await _apiService.getWorkOrders(empId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }
}
