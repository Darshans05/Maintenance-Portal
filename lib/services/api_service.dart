import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../models/user.dart';
import '../models/notification_item.dart';
import '../models/work_order_item.dart';

class ApiService {
  // Simple basic auth or custom headers if needed in the future
  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  Future<User?> login(String empId, String password) async {
    // In a real SAP environment, login might be basic auth, 
    // or a specific endpoint. Here we mock validation or do a simple GET.
    // If there is an actual POST endpoint, it would be configured here.
    // Assuming for this prototype, any non-empty login is successful and returns a User.
    // To implement real API login:
    /*
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/LoginSet'),
      headers: _headers,
      body: jsonEncode({'EMP_ID': empId, 'PASSWORD': password}),
    );
    if (response.statusCode == 200) {
       return User.fromJson(jsonDecode(response.body)['d']);
    }
    */
    
    // Mock successful login:
    await Future.delayed(const Duration(seconds: 1));
    if (empId.isNotEmpty && password.isNotEmpty) {
      return User(empId: empId, name: 'John Doe');
    }
    throw Exception('Invalid credentials');
  }

  Future<List<NotificationItem>> getNotifications(String empId) async {
    // Note: removed EMP_ID filter because SAP entity might not have it, 
    // matching the Postman URL provided.
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notificationSet}?\$format=json');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['d'] != null && data['d']['results'] != null 
                             ? data['d']['results'] 
                             : (data['d'] != null ? [data['d']] : []);
        return results.map((e) => NotificationItem.fromJson(e)).toList();
      } else {
        print('Error response: \${response.statusCode} - \${response.body}');
        throw Exception('Failed to load notifications: \${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notifications: \$e');
      throw Exception('Network error: \$e');
    }
  }

  Future<NotificationItem> getNotificationDetail(String qmNum) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notificationSet}(\'$qmNum\')?\$format=json');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data['d'] ?? data;
        return NotificationItem.fromJson(result);
      } else {
        throw Exception('Failed to load notification detail');
      }
    } catch (e) {
      print('Error fetching notification detail: \$e');
      throw Exception('Network error');
    }
  }

  Future<List<WorkOrderItem>> getWorkOrders(String empId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.workOrderSet}?\$format=json&sap-client=100');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['d'] != null && data['d']['results'] != null 
                             ? data['d']['results'] 
                             : (data['d'] != null ? [data['d']] : []);
        return results.map((e) => WorkOrderItem.fromJson(e)).toList();
      } else {
        print('Error response: \${response.statusCode} - \${response.body}');
        throw Exception('Failed to load work orders: \${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching work orders: \$e');
      throw Exception('Network error: \$e');
    }
  }

  Future<WorkOrderItem> getWorkOrderDetail(String aufnr) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.workOrderSet}(\'$aufnr\')?\$format=json');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data['d'] ?? data;
        return WorkOrderItem.fromJson(result);
      } else {
        throw Exception('Failed to load work order detail');
      }
    } catch (e) {
      print('Error fetching work order detail: \$e');
      throw Exception('Network error');
    }
  }
}
