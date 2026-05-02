import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/notification_item.dart';

class NotificationProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<NotificationItem> _notifications = [];
  bool _isLoading = false;
  String _error = '';

  List<NotificationItem> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchNotifications(String empId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _notifications = await _apiService.getNotifications(empId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Future method if we need to fetch individual detail differently 
  // currently we can just pass the object to the next screen if list has all details
  Future<NotificationItem?> getDetail(String qmNum) async {
    try {
      return await _apiService.getNotificationDetail(qmNum);
    } catch (e) {
      return null;
    }
  }
}
